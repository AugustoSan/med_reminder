

import '../database_helper.dart';
import '../models/models.dart';
import 'daos.dart';

class ScheduleDao {
  final DatabaseHelper _helper = DatabaseHelper();
  final MedicationDAO _medicationDao = MedicationDAO();
  final HistoryDao _historyDao = HistoryDao();

  // Future<int> insertSchedule(MedicationSchedule schedule) async {
  //   final db = await _helper.database;
  //   return await db.insert('medication_schedules', schedule.toMap());
  // }

  Future<int> insertSchedule(MedicationScheduleEntity schedule) async {
    final db = await _helper.database;
    int medicationId = schedule.medication.id ?? 0;
    if(schedule.medication.id  == null) {
      medicationId = await _medicationDao.insertMedication(schedule.medication);
    }

    final medicationSchedule = MedicationSchedule(medicationId: medicationId, hora: schedule.hora, dias: schedule.dias, frecuencia: schedule.frecuencia, dosis: schedule.dosis);

    final scheduleId = await db.insert('medication_schedules', medicationSchedule.toInsertMap());

    for (var element in schedule.history) {
      await _historyDao.insertDoseHistory(DoseHistory(id:0, scheduleId: scheduleId, fecha: element.fecha, estado: element.estado));
    }
    return scheduleId;
  }

  Future<List<MedicationSchedule>> getAllScheduleMedications() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'activo = ?',
      orderBy: 'id DESC',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => MedicationSchedule.fromMap(maps[i]));
  }

  // Buscar por ID
  Future<MedicationSchedule?> getScheduleMedicationById(int id) async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MedicationSchedule.fromMap(maps.first);
    }
    return null;
  }

  // Buscar por ID
  Future<Medication?> _getMedicationById(int id) async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DoseHistory>> _getDoseHistoryById(int id) async {
    final db = await _helper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: 'scheduleId LIKE ?',
      whereArgs: [id],
      orderBy: 'fecha ASC',
    );
    
    return List.generate(maps.length, (i) => DoseHistory.fromMap(maps[i]));
  }

  Future<List<MedicationScheduleEntity>> getAllScheduleMedicationsEntity() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_schedules',
      where: 'activo = ?',
      orderBy: 'id DESC',
      whereArgs: [1],
    );
    
    final List<MedicationSchedule> listMaps = List.generate(
      maps.length, 
      (i) => MedicationSchedule.fromMap(maps[i])
    );
    
    // Usar Future.wait para ejecutar todas las operaciones asíncronas en paralelo
    final List<MedicationScheduleEntity?> nullableEntities = await Future.wait(
      listMaps.map((item) async {
        final Medication? med = await _getMedicationById(item.medicationId);
        final List<DoseHistory> history = await _getDoseHistoryById(item.id ?? 0);
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