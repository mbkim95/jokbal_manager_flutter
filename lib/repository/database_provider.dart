import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider provider = DatabaseProvider();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await openDatabase(
        join(await getDatabasesPath(), "jokbal_manager.db"),
        onCreate: (db, version) => _createDB(db),
        version: 1);
    return _db!;
  }

  static Future _createDB(Database db) async {
    await db.execute(
        'CREATE TABLE orders(date TEXT, type INTEGER, price INTEGER, weight REAL, deposit INTEGER, PRIMARY KEY (date, type))');
  }
}
