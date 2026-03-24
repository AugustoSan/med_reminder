import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // Singleton: una sola instancia de DatabaseHelper
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'med_reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        color TEXT NOT NULL DEFAULT '#4A90D9',
        icono TEXT NOT NULL DEFAULT 'pill',
      )
    ''');

    await db.execute('''
      CREATE TABLE medication_schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER NOT NULL,
        hora TEXT NOT NULL,
        dias TEXT NOT NULL,
        frecuencia INTEGER NOT NULL,
        dosis TEXT NOT NULL,
        intervaloHoras INTEGER,
        instrucciones TEXT,
        FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE dose_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scheduleId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        estado INTEGER NOT NULL,
        FOREIGN KEY (scheduleId) REFERENCES medication_schedules (id) ON DELETE CASCADE
      )
    ''');

    // Índices para mejorar el rendimiento
    await db.execute('CREATE INDEX idx_history_fecha ON dose_history (fecha)');
    await db.execute('CREATE INDEX idx_schedules_med ON medication_schedules (medicationId)');
  }

}