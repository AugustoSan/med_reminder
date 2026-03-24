import 'package:flutter/material.dart';
// import 'package:med_reminder/database/dao/daos.dart';
// import 'package:med_reminder/alarms/alarm_service.dart';
import 'package:med_reminder/screens/add_medication_screen.dart';
import 'package:med_reminder/utils/medications_utils.dart';

import '../database/models/models.dart';
// import 'package:med_reminder/database/models/medication_schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<MedicationScheduleEntity> _medicamentosSchedule = [
    new MedicationScheduleEntity(id: 1, dosis: '1 tableta', hora: '3:00', dias: '[1,2,3,4,5]', frecuencia: Frecuencia.diaria, medication: new Medication(nombre: 'Paracetamol'), history: [
      DoseHistory(id: 1, scheduleId: 1, fecha: DateTime.now().add(Duration(hours: -12)).toString(),estado: DoseEstado.perdida),
      DoseHistory(id: 2, scheduleId: 1, fecha: DateTime.now().add(Duration(hours: -6)).toString(),estado: DoseEstado.tomada),
      DoseHistory(id: 3, scheduleId: 1, fecha: DateTime.now().toString(),estado: DoseEstado.pendiente),
      DoseHistory(id: 4, scheduleId: 1, fecha: DateTime.now().add(Duration(hours: 6)).toString(),estado: DoseEstado.pendiente),
    ], ),
    new MedicationScheduleEntity(id: 2, dosis: '1/2 capsula', hora: '3:00', dias: '[1,2,3,4,5]', frecuencia: Frecuencia.diaria, medication: new Medication(nombre: 'Tramadol'), history: [
      DoseHistory(id: 5, scheduleId: 2, fecha: DateTime.now().add(Duration(hours: -12)).toString(),estado: DoseEstado.tomada),
      DoseHistory(id: 6, scheduleId: 2, fecha: DateTime.now().add(Duration(hours: -6)).toString(),estado: DoseEstado.perdida),
      DoseHistory(id: 7, scheduleId: 2, fecha: DateTime.now().toString(),estado: DoseEstado.pendiente),
      DoseHistory(id: 9, scheduleId: 2, fecha: DateTime.now().add(Duration(hours: 6)).toString(),estado: DoseEstado.pendiente),
    ], ),
  ]; 

  // List<MedicationScheduleEntity> _medicamentosSchedule = [];
  int _pendientes = 3;


  @override
  void initState() {
    super.initState();
    
  }

  void init() async {
    // final newScheduleMedications = await ScheduleDao().getAllScheduleMedicationsEntity();
    // final pendientes = await HistoryDao().getHoy();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    List<DoseHistory> todayPendingDoses = [];
    
    for (var med in _medicamentosSchedule) {
      // Buscar dosis pendientes de hoy
      todayPendingDoses = med.history.where((dose) {
        final doseDate = dose.fecha.split(' ')[0]; // Si formato "2024-01-15 08:00:00"
        // Si es formato ISO: dose.fecha.split('T')[0]
        return doseDate == todayString && dose.estado == DoseEstado.pendiente;
      }).toList();
      
    }

    setState(() {
      // _medicamentosSchedule = newScheduleMedications;
      _pendientes = todayPendingDoses.length;
    });
  }

  Widget _buildResumenDia(int pendientes) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dosis de hoy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$pendientes pendiente${pendientes == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medication_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicamentoCard(MedicationScheduleEntity schedule) {
    final color = MedicationsUtils.hexToColor(schedule.medication.color);

    Color estadoColor;
    IconData estadoIcon;
    String estadoLabel;

    final ultimaDosis = schedule.history.last;

    switch (ultimaDosis.estado) {
      case DoseEstado.tomada:
        estadoColor = const Color(0xFF16A34A);
        estadoIcon = Icons.check_circle_rounded;
        estadoLabel = 'Tomado';
        break;
      case DoseEstado.perdida:
        estadoColor = const Color(0xFFDC2626);
        estadoIcon = Icons.cancel_rounded;
        estadoLabel = 'Perdido';
        break;
      default:
        estadoColor = const Color(0xFF2563EB);
        estadoIcon = Icons.access_time_rounded;
        estadoLabel = 'Pendiente';
    }

    estadoColor = const Color(0xFF2563EB);
        estadoIcon = Icons.access_time_rounded;
        estadoLabel = 'Pendiente';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.medication_rounded,
            color: color,
            size: 26,
          ),
        ),
        title: Text(
          schedule.medication.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF1A2D4F),
          ),
        ),
        subtitle: Text(
          '${schedule.dosis} · ${ultimaDosis.fecha}',
          style: const TextStyle(
            color: Color(0xFF8A99B0),
            fontSize: 13,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(estadoIcon, color: estadoColor, size: 20),
            const SizedBox(height: 2),
            Text(
              estadoLabel,
              style: TextStyle(
                color: estadoColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 48,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin medicamentos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A2D4F),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca "Agregar" para registrar\ntu primer medicamento',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A99B0),
            ),
          ),
        ],
      ),
    );
  }

  String _fechaHoy() {
    final now = DateTime.now();
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    const dias = [
      'lunes', 'martes', 'miércoles', 'jueves',
      'viernes', 'sábado', 'domingo'
    ];
    return '${dias[now.weekday - 1]}, ${now.day} de ${meses[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final hoy = _fechaHoy();
    // final pendientes = _pendientes
    //   .where((m) => m.estado == DoseEstado.pendiente)
    //   .length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mis medicamentos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2D4F),
              ),
            ),
            Text(
              hoy,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8A99B0),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE8F0FE),
              child: Text(
                '$_pendientes',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildResumenDia(_pendientes),
          Expanded(
            child: _medicamentosSchedule.isEmpty
              ? _buildEstadoVacio()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _medicamentosSchedule.length,
                  itemBuilder: (context, index) {
                    return _buildMedicamentoCard(_medicamentosSchedule[index]);
                  }
                )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const AddMedicationScreen() )
          );
        }, 
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white,),
        label: const Text(
          'Agregar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),
        )
      ),
    );
  }
}