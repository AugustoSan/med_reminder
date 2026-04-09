

import '../database_helper.dart';
import '../models/models.dart';
import 'services.dart';

class ScheduleService {
  final DatabaseHelper _helper = DatabaseHelper();
  final MedicationService _medicationService = MedicationService();
  final HistoryService _historyService = HistoryService();

  // Future<int> insertSchedule(MedicationSchedule schedule) async {
  //   final db = await _helper.database;
  //   return await db.insert('medication_schedules', schedule.toMap());
  // }

  Future<int> insertSchedule(MedicationScheduleEntity schedule) async {
    final db = await _helper.database;
    int medicationId = schedule.medication.id ?? 0;
    if(schedule.medication.id  == null) {
      medicationId = await _medicationService.insertMedication(schedule.medication);
    }

    final medicationSchedule = MedicationScheduleModel(medicationId: medicationId, hora: schedule.hora, dias: schedule.dias, frecuencia: schedule.frecuencia, dosis: schedule.dosis);

    final scheduleId = await db.insert('medication_schedules', medicationSchedule.toInsertMap());

    for (var element in schedule.history) {
      await _historyService.insertDoseHistory(DoseHistoryModel(id:0, scheduleId: scheduleId, fecha: element.fecha, estado: element.estado));
    }
    return scheduleId;
  }

  Future<List<MedicationScheduleModel>> getAllScheduleMedications() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'activo = ?',
      orderBy: 'id DESC',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => MedicationScheduleModel.fromMap(maps[i]));
  }

  // Buscar por ID
  Future<MedicationScheduleModel?> getScheduleMedicationById(int id) async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MedicationScheduleModel.fromMap(maps.first);
    }
    return null;
  }

  // Buscar por ID
  Future<MedicationModel?> _getMedicationById(int id) async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MedicationModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DoseHistoryModel>> _getDoseHistoryById(int id) async {
    final db = await _helper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: 'scheduleId LIKE ?',
      whereArgs: [id],
      orderBy: 'fecha ASC',
    );
    
    return List.generate(maps.length, (i) => DoseHistoryModel.fromMap(maps[i]));
  }

  Future<List<MedicationScheduleEntity>> getAllScheduleMedicationsEntity() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'activo = ?',
      orderBy: 'id DESC',
      whereArgs: [1],
    );
    
    final List<MedicationScheduleModel> listMaps = List.generate(
      maps.length, 
      (i) => MedicationScheduleModel.fromMap(maps[i])
    );
    
    // Usar Future.wait para ejecutar todas las operaciones asíncronas en paralelo
    final List<MedicationScheduleEntity?> nullableEntities = await Future.wait(
      listMaps.map((item) async {
        final MedicationModel? med = await _getMedicationById(item.medicationId);
        final List<DoseHistoryModel> history = await _getDoseHistoryById(item.id ?? 0);
        if (med == null) return null;
        return MedicationScheduleEntity(
          id: item.id ?? -1,
          medication: med,
          hora: item.hora,
          dias: item.dias,
          frecuencia: item.frecuencia,
          dosis: item.dosis,
          history: history,
        );
      }).toList(),
    );
    
    final List<MedicationScheduleEntity> entities = nullableEntities
      .where((entity) => entity != null)
      .cast<MedicationScheduleEntity>()
      .toList();
  
    return entities;
  }
}