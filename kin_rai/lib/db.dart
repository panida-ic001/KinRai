import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'fitbit.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE heart_rate(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            restingHeartRate INTEGER,
            fetchedAt TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<void> insertHeartRate({
    required String date,
    required int restingHR,
  }) async {
    final db = await instance();
    await db.insert('heart_rate', {
      'date': date,
      'restingHeartRate': restingHR,
      'fetchedAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getAllHeartRates() async {
    final db = await instance();
    return await db.query('heart_rate', orderBy: 'id DESC');
  }
}
