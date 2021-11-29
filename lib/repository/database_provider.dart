import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider provider = DatabaseProvider();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await createDB("jokbal_manager.db", "orders");
    return _db!;
  }

  Future createDB(String dbName, String tableName) async {
    var db = await openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName (date TEXT PRIMARY KEY, type INTEGER PRIMARY KEY, price INTEGER, weight REAL, deposit INTEGER');
    }, onUpgrade: (db, oldVersion, newVersion) {
      // migrate db
    });
  }
}
