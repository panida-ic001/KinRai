import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health.db');
    return _database!;
  }

  Future<HealthData?> getLatestHealthData() async {
    final db = await database;
    // ดึงข้อมูลโดยเรียงจาก id ล่าสุด (มากไปน้อย) และเอาแค่ 1 แถว
    final List<Map<String, dynamic>> maps = await db.query(
      'health_data',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return HealthData.fromMap(maps.first); // แปลง Map เป็น Object HealthData
    }
    return null; // คืนค่า null ถ้ายังไม่มีข้อมูลใน DB
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final db = await openDatabase(path, version: 1);
    await _createTables(db);
    return db;
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        heart_rate REAL,
        sleep REAL,
        spO2 REAL,
        hrv REAL,
        calories REAL,
        record_time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS bg_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        run_type TEXT,
        created_at TEXT
      )
    ''');

    // await db.execute('''
    //   CREATE TABLE IF NOT EXISTS Token (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     accessToken TEXT,
    //     refreshToken TEXT,
    //     expries TEXT
    //   )
    // ''');
  }

  Future<void> insertBgLog({
    required String message,
    required String runType,
  }) async {
    final db = await database;
    await db.insert('bg_log', {
      'message': message,
      'run_type': runType,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> insertHealthData(HealthData data) async {
    final db = await database;
    return await db.insert('health_data', data.toMap());
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return await db.query('health_data');
  }
}
