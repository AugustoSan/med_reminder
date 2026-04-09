import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class AlarmRingingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingingScreen({
    super.key,
    required this.alarmSettings,
  });

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(
          parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Hora actual
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, _) {
                  final now = TimeOfDay.now();
                  return Text(
                    now.format(context),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF1A2D4F),
                      letterSpacing: -2,
                    ),
                  );
                },
              ),

              const Text(
                'Es hora de tu medicamento',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A99B0),
                ),
              ),

              const Spacer(),

              // Ícono pulsante
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Nombre del medicamento
              Text(
                widget.alarmSettings.notificationSettings.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2D4F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.alarmSettings.notificationSettings.body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A99B0),
                ),
              ),

              const Spacer(),

              // Botón TOMÉ MI DOSIS
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _detenerAlarma(tomada: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Tomé mi dosis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Botón POSPONER
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => _posponer(minutos: 10),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(
                        color: Color(0xFF2563EB), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.snooze_rounded, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Posponer 10 minutos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Botón SALTAR
              TextButton(
                onPressed: () => _detenerAlarma(tomada: false),
                child: const Text(
                  'Saltar esta dosis',
                  style: TextStyle(
                    color: Color(0xFF8A99B0),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _detenerAlarma({required bool tomada}) async {
    await Alarm.stop(widget.alarmSettings.id);
    // Aquí registras en la BD: estado = tomada ? 'tomada' : 'saltada'
    if (mounted) Navigator.pop(context);
  }

  Future<void> _posponer({required int minutos}) async {
    await Alarm.stop(widget.alarmSettings.id);
    // Reprograma en X minutos
    final nuevaHora = DateTime.now().add(Duration(minutes: minutos));
    await Alarm.set(
      alarmSettings: widget.alarmSettings.copyWith(
        dateTime: nuevaHora,
      ),
    );
    if (mounted) Navigator.pop(context);
  }
}