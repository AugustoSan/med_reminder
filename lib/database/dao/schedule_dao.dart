

import '../database_helper.dart';
import '../models/models.dart';

class ScheduleDao {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> insertSchedule(MedicationSchedule schedule) async {
    final db = await _helper.database;
    return await db.insert('medication_schedules', schedule.toMap());
  }
}