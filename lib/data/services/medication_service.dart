import '../database_helper.dart';
import '../models/models.dart';

class MedicationService {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> insertMedication(MedicationModel medication) async {
    final db = await _helper.database;
    return await db.insert('medications', medication.toInsertMap());
  }

  Future<List<MedicationModel>> getAllMedications() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
    );
    return List.generate(maps.length, (i) => MedicationModel.fromMap(maps[i]));
  }

  // Obtener todos los medicamentos activos
  Future<List<MedicationModel>> getActiveMedications() async {
    final db = await _helper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => MedicationModel.fromMap(maps[i]));
  }

  // Buscar por ID
  Future<MedicationModel?> getMedicationById(int id) async {
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

  // Actualizar medicamento
  Future<int> updateMedication(MedicationModel medication) async {
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