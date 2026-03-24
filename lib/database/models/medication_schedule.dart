import 'package:med_reminder/database/models/dose_history.dart';
import 'package:med_reminder/database/models/medication.dart';

enum Frecuencia {
  diaria,
  semanal,
  mensual,
  cadaXdias;
  
  static Frecuencia fromIndex(int index) {
    if (index >= 0 && index < values.length) {
      return values[index];
    }
    return diaria;
  }
}

class MedicationSchedule {
  final int? id;
  final int medicationId;
  final String hora; // Ejemplo: "08:00"
  final String dias; // Ejemplo: '[1,2,3,4,5]' (1=lun … 7=dom)
  final Frecuencia frecuencia; // Ejemplo: "diaria", "semanal", "mensual", "cada X días"
  final String dosis;
  final int? intervaloHoras; // Solo para "cada X días"
  final String? instrucciones;

  MedicationSchedule({
    this.id,
    required this.medicationId,
    required this.hora,
    required this.dias,
    required this.frecuencia,
    required this.dosis,
    this.intervaloHoras,
    this.instrucciones,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'hora': hora,
      'dias': dias,
      'frecuencia': frecuencia.index,
      'dosis': dosis,
      'intervaloHoras': intervaloHoras,
      'instrucciones': instrucciones
    };
  }

  // Método específico para inserción (sin ID)
  Map<String, dynamic> toInsertMap() {
    return {
      'medicationId': medicationId,
      'hora': hora,
      'dias': dias,
      'frecuencia': frecuencia.index,
      'dosis': dosis,
      'intervaloHoras': intervaloHoras,
      'instrucciones': instrucciones
    };
  }

  factory MedicationSchedule.fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      id: map['id'],
      medicationId: map['medicationId'],
      hora: map['hora'],
      dias: map['dias'],
      frecuencia: Frecuencia.fromIndex(map['frecuencia']),
      dosis: map['dosis'],
      intervaloHoras: map['intervaloHoras'],
      instrucciones: map['instrucciones']
    );
  }
}

class MedicationScheduleEntity {
  final int id;
  final Medication medication;
  final String hora; // Ejemplo: "08:00"
  final String dias; // Ejemplo: '[1,2,3,4,5]' (1=lun … 7=dom)
  final Frecuencia frecuencia; // Ejemplo: "diaria", "semanal", "mensual", "cada X días"
  final String dosis;
  final int? intervaloHoras; // Solo para "cada X días"
  final String? instrucciones;
  final List<DoseHistory> history;

  MedicationScheduleEntity({
    required this.id,
    required this.medication,
    required this.hora,
    required this.dias,
    required this.frecuencia,
    required this.dosis,
    required this.history,
    this.intervaloHoras,
    this.instrucciones
  });
}