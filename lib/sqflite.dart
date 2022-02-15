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

  static Future<List<Alarm>> getData() async {
    final List<Map<String, dynamic>> maps = await database!.query(tableName);
    if (maps.isEmpty) {
      return [];
    } else {
      List<Alarm> alarmList = List.generate(maps.length, (index) => Alarm(
        id: maps[index]['id'],
        alarmTime: DateTime.parse(maps[index]['alarm_time']),
        isActive: maps[index]['is_active'] == 0 ? true : false
      ));
      return alarmList;
    }
  }

  static Future<void> updateData(Alarm alarm) async {
    await database!.update(tableName, {
      'alarm_time': alarm.alarmTime.toString(),
      'is_active': alarm.isActive ? 0 : 1
    },
      where: 'id = ?',
      whereArgs: [alarm.id]
    );
  }

  static Future<void> deleteData(Alarm alarm) async {
    await database!.delete(tableName, where: 'id = ?', whereArgs: [alarm.id]);
  }
}