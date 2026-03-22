import 'package:flutter/material.dart';
import 'package:med_reminder/alarms/alarm_service.dart';
import 'package:med_reminder/database/models/medication.dart';
import 'package:med_reminder/database/models/medication_schedule.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              final date = DateTime.now().add(new Duration(minutes: 1));
              AlarmService.programar(
                med: Medication(id: 1, nombre: 'Paracetamol', dosis: '1 pastilla'), 
                schedule: MedicationSchedule(
                  id: 1,
                  medicationId: 1, 
                  hora: '${date.hour}:${date.minute}', 
                  dias: date.day.toString(), 
                  frecuencia: 'diaria'
                ));
            }, 
            child: const Text('Agregar alarma')
          ),
          ElevatedButton(
            onPressed: () {
              AlarmService.cancelarTodas();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,      // color de fondo
              foregroundColor: Colors.white,     // color del texto e icono
            ),
            child: const Text('Cancelar'),
          )
        ],
      ),
    );
  }
}