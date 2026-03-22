import 'package:med_reminder/database/database_helper.dart';

import '../models/models.dart';

class HistoryDao {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> insertDoseHistory(DoseHistory history) async {
    final db = await _helper.database;
    return await db.insert('dose_history', history.toMap());
  }

  // Historial de los ultimos N dias para un scheduleId
  Future<List<DoseHistory>> getUltimos({int dias = 30}) async {
    final db = await _helper.database;
    final desde = DateTime.now()
      .subtract(Duration(days: dias))
      .toIso8601String();
    
    final maps = await db.query(
      'dose_history',
      where: 'fecha >= ?',
      whereArgs: [desde],
      orderBy: 'fecha DESC',
    );

    return maps.map((m) => DoseHistory.fromMap(m)).toList();
  }

  Future<List<DoseHistory>> getHoy() async {
    final db = await _helper.database;
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    
    final maps = await db.query(
      'dose_history',
      where: 'fecha LIKE ?',
      whereArgs: ['$hoy%'],
      orderBy: 'fecha DESC',
    );

    return maps.map((m) => DoseHistory.fromMap(m)).toList();
  }
}