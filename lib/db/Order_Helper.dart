import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OrderHelper {
  static Future<Database> openOrdersDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orders.db');
    return openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE siparisler (
            id INTEGER PRIMARY KEY,
            title TEXT,
            category TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> addOrder(Map<String, dynamic> order) async {
    final Database database = await openOrdersDatabase();
    await database.insert(
      'siparisler',
      order,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await database.close();
  }
}