import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:med_reminder/alarms/alarm_callback.dart';

import '../database/models/models.dart';

class AlarmService {
  // Inicializa el sistema de alarmas
  static Future<void> init() async {
    await Alarm.init();

    // Escucha cuando el usuario detiene una alarma que esta sonando
    Alarm.ringing.listen((AlarmSet alarmSet) {
      for (final alarm in alarmSet.alarms) {
        print('🔔 Sonando: ${alarm.notificationSettings.title}');
      }
    });
  }

  // Programa una alarma para un horario de medicamento
  static Future<void> programar({
    required Medication med,
    required MedicationSchedule schedule,
  }) async {
    final ahora = DateTime.now();
    final partes = schedule.hora.split(':');
    final hora = int.parse(partes[0]);
    final minuto = int.parse(partes[1]);

    // Construye la fecha/hora de la próxima dosis
    DateTime proximaDosis = DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
      hora,
      minuto,
    );

    // Si la hora ya pasó hoy, programa para mañana
    if (proximaDosis.isBefore(ahora)) {
      proximaDosis = proximaDosis.add(const Duration(days: 1));
    }

    final settings = AlarmSettings(
      id: schedule.id!, // el id del schedule es el id de la alarma
      dateTime: proximaDosis,
      assetAudioPath: 'assets/sounds/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        fadeDuration: Duration(seconds: 5),
      ),
      notificationSettings: NotificationSettings(
        title: '💊 ${med.nombre}',
        body: '${med.dosis} · ${schedule.hora}',
        stopButton: 'Tomé mi dosis',
        icon: 'notification_icon',
      ),
      warningNotificationOnKill: true, // avisa si el SO mata la app
    );

    await Alarm.set(alarmSettings: settings);
    print('✅ Alarma programada: ${med.nombre} a las ${schedule.hora}');
  }

  // Programa alarmas para TODOS los días de la semana configurados
  static Future<void> programarSemana({
    required Medication med,
    required MedicationSchedule schedule,
  }) async {
    // dias_semana viene como JSON string: '[1,2,3,4,5]'
    // 1=lunes, 7=domingo (igual que DateTime.weekday en Dart)
    final dias = _parseDias(schedule.dias);
    final ahora = DateTime.now();
    final partes = schedule.hora.split(':');
    final hora = int.parse(partes[0]);
    final minuto = int.parse(partes[1]);

    for (final dia in dias) {
      // Encuentra el próximo día de la semana correspondiente
      int diasHasta = (dia - ahora.weekday + 7) % 7;

      // Si es hoy pero la hora ya pasó, programa para la semana siguiente
      if (diasHasta == 0) {
        final horaHoy = DateTime(ahora.year, ahora.month, ahora.day, hora, minuto);
        if (horaHoy.isBefore(ahora)) diasHasta = 7;
      }

      final fechaDosis = DateTime(
        ahora.year, ahora.month,
        ahora.day + diasHasta,
        hora, minuto,
      );

      // Usa un id único combinando schedule id + día de la semana
      // Ejemplo: schedule.id=3, dia=2 → alarmId=3002
      final alarmId = (schedule.id! * 10) + dia;

      final settings = AlarmSettings(
        id: alarmId,
        dateTime: fechaDosis,
        assetAudioPath: 'assets/sounds/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volumeSettings: VolumeSettings.fade(
          fadeDuration: Duration(seconds: 5),
        ),
        notificationSettings: NotificationSettings(
          title: '💊 ${med.nombre}',
          body: '${med.dosis} · ${schedule.hora}',
          stopButton: 'Tomé mi dosis',
          icon: 'notification_icon',
        ),
      );

      await Alarm.set(alarmSettings: settings);
    }
  }

  // Cancelar todas las alarmas de un horario
  static Future<void> cancelar(int scheduleId) async {
    // Cancela alarmas del id base y todas las combinaciones de días
    await Alarm.stop(scheduleId);
    for (int dia = 1; dia <= 7; dia++) {
      await Alarm.stop((scheduleId * 10) + dia);
    }
  }

  // Cancelar TODAS las alarmas de la app
  static Future<void> cancelarTodas() async {
    await Alarm.stopAll();
  }

  // Reprograma todas las alarmas activas — úsalo al reiniciar el teléfono
  static Future<void> reprogramarTodas({
    required List<Medication> meds,
    required List<MedicationSchedule> schedules,
  }) async {
    await Alarm.stopAll();
    for (final schedule in schedules) {
      final med = meds.firstWhere((m) => m.id == schedule.medicationId);
      await programarSemana(med: med, schedule: schedule);
    }
    print('🔄 Todas las alarmas reprogramadas');
  }

  // Convierte el string JSON '[1,2,5]' a lista de enteros [1, 2, 5]
  static List<int> _parseDias(String diasJson) {
    final limpio = diasJson.replaceAll(RegExp(r'[\[\]\s]'), '');
    if (limpio.isEmpty) return [1, 2, 3, 4, 5, 6, 7];
    return limpio.split(',').map((d) => int.parse(d.trim())).toList();
  }

}