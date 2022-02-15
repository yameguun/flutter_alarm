import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'alarm.dart';

class DbProvider {
  static Database? database;
  static const String tableName = 'alarm';

  static Future<void> _createdTable(Database db, int version) async {
    await db.execute('CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, alarm_time TEXT, is_active INTEGER)');
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'alarm_app.db');
    return await openDatabase(path, version: 1, onCreate: _createdTable);
  }

  static Future<Database?> setDb() async {
    if (database == null) {
      database = await initDb();
      return database;
    } else {
      return database;
    }
  }

  static Future<void> insertData(Alarm alarm) async {
    await database!.insert(tableName, {
      'alarm_time': alarm.alarmTime.toString(),
      'is_active': alarm.isActive ? 0 : 1
    });
  }
}