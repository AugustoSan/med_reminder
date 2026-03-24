import '../database_helper.dart';
import '../models/models.dart';

class MedicationDAO {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> insertMedication(Medication medication) async {
    final db = await _helper.database;
    return await db.insert('medications', medication.toInsertMap());
  }

  // Obtener todos los medicamentos activos
  Future<List<Medication>> getActiveMedications() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Medication.fromMap(maps[i]));
  }

  // Buscar por ID
  Future<Medication?> getMedicationById(int id) async {
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

  // Actualizar medicamento
  Future<int> updateMedication(Medication medication) async {
    final db = await _helper.database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  // archivar medicamento (activo = 0)
  Future<int> archiveMedication(int id) async {
    final db = await _helper.database;
    return await db.update(
      'medications',
      {'activo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar medicamento (borrado físico)
  Future<int> deleteMedication(int id) async {
    final db = await _helper.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}