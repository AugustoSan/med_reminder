import 'package:med_reminder/database/database_helper.dart';

import '../models/models.dart';

class HistoryDao {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> insertDoseHistory(DoseHistory history) async {
    final db = await _helper.database;
    return await db.insert('dose_history', history.toInsertMap());
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

  Future<List<DoseHistory>> getTodayDoseHistory() async {
    final db = await _helper.database;
    
    // Obtener la fecha actual en el mismo formato que guardas
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: 'fecha LIKE ?',
      whereArgs: ['$todayString%'], // Busca todas las horas del día
      orderBy: 'fecha ASC',
    );
    
    return List.generate(maps.length, (i) => DoseHistory.fromMap(maps[i]));
  }

  Future<List<DoseHistory>> getDoseHistoryById(int id) async {
    final db = await _helper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: 'scheduleId LIKE ?',
      whereArgs: [id],
      orderBy: 'fecha ASC',
    );
    
    return List.generate(maps.length, (i) => DoseHistory.fromMap(maps[i]));
  }
}