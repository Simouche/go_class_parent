import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  static final LocalDB _db = LocalDB._internal();
  final String dbName = "go_class_db.db";
  final int version = 6;
  Database db;

  factory LocalDB() {
    return _db;
  }

  LocalDB._internal() {
    prepareDB();
  }

  void prepareDB() async {
    final String dbPath = await getDatabasesPath();
    final String dbFullPath = join(dbPath, dbName);
    db = await openDatabase(
      dbFullPath,
      version: version,
      onCreate: (Database database, int version) async {
        await database.execute("CREATE TABLE IF NOT EXISTS users("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "USERNAME TEXT ,"
            "SERVER_ID TEXT ,"
            "AUTH_TOKEN TEXT );");
        await database.execute("CREATE TABLE IF NOT EXISTS parents("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SERVER_ID TEXT ,"
            "FIRST_NAME TEXT ,"
            "LAST_NAME TEXT ,"
            "PHONE TEXT ,"
            "PERSONAL_ID TEXT ,"
            "EMAIL TEXT ,"
            "CODE TEXT );");
        await database.execute("CREATE TABLE IF NOT EXISTS messages("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "CONTACT INTEGER ,"
            "MESSAGE TEXT ,"
            "DATE DATETIME ,"
            "SEEN INTEGER DEFAULT 0,"
            "OWNER INTEGER DEFAULT 0);");
        await database.execute("CREATE TABLE IF NOT EXISTS notifications("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "DATE DATETIME ,"
            "NEW INTEGER DEFAULT 1,"
            "MESSAGE TEXT ,"
            "TITLE TEXT ,"
            "FROM_ TEXT );");
        await database.execute("CREATE TABLE IF NOT EXISTS downloads("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "DATE DATETIME,"
            "PATH TEXT,"
            "TYPE TEXT," //notification or messages
            "EXTENSION TEXT,"
            "NAME TEXT,"
            "URL TEXT);");
        await database.execute("CREATE TABLE IF NOT EXISTS settings("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "CONFIG TEXT NOT NULL,"
            "VALUE TEXT DEFAULT 0);");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print("upgrading db to $newVersion");
        if (newVersion <= 5) {
          await db.execute("DROP TABLE IF EXISTS downloads;");
          await db.execute("CREATE TABLE IF NOT EXISTS downloads("
              "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
              "DATE DATETIME,"
              "PATH TEXT,"
              "TYPE TEXT," //notification or messages
              "EXTENSION TEXT,"
              "NAME TEXT,"
              "URL TEXT);");
        }
        if (newVersion <= 6)
          await db.execute("ALTER TABLE parents ADD CODE TEXT;");
      },
    );
  }

  Future<int> insert({String tableName, Map<String, dynamic> values}) async {
    if (db.isOpen) {
      return db.insert(tableName, values);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> query(
      {String tableName,
      List<String> columns,
      String where,
      List whereArgs,
      bool distinct,
      String groupBy,
      String having,
      int limit,
      int offset}) async {
    if (db == null) await prepareDB();

    if (db.isOpen) {
      return await db.query(tableName,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          distinct: distinct,
          groupBy: groupBy,
          having: having,
          limit: limit,
          offset: offset);
    }
    return null;
  }

  Future<int> delete(
      {@required String tableName,
      String where,
      List<dynamic> whereArgs}) async {
    if (db.isOpen)
      return await db.delete(tableName, where: where, whereArgs: whereArgs);
    return null;
  }

  Future<int> update(
      {@required String tableName,
      Map<String, dynamic> values,
      String where,
      List<dynamic> whereArgs}) async {
    if (db.isOpen)
      return db.update(tableName, values, where: where, whereArgs: whereArgs);

    return null;
  }
}
