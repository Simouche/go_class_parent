import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  static final LocalDB _db = LocalDB._internal();
  final String dbName = "go_class_db2.db";
  final int version = 1;
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
            "SERVER_ID TEXT UNIQUE ,"
            "AUTH_TOKEN TEXT );");
        await database.execute("CREATE TABLE IF NOT EXISTS parents("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SERVER_ID TEXT UNIQUE ,"
            "FIRST_NAME TEXT ,"
            "LAST_NAME TEXT ,"
            "PHONE TEXT ,"
            "PERSONAL_ID TEXT ,"
            "EMAIL TEXT ,"
            "CODE TEXT );");
        await database.execute("CREATE TABLE IF NOT EXISTS ceo("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "NAME TEXT,"
            "EMAIL TEXT,"
            "PHONE TEXT,"
            "SERVER_ID TEXT UNIQUE"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS directors("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "NAME TEXT,"
            "EMAIL TEXT,"
            "PHONE TEXT,"
            "SERVER_ID TEXT UNIQUE"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS students("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SERVER_ID TEXT UNIQUE,"
            "FIRST_NAME TEXT,"
            "LAST_NAME TEXT ,"
            "STATE TEXT,"
            "DIRECTOR TEXT"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS teachers("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SERVER_ID TEXT UNIQUE,"
            "FIRST_NAME TEXT,"
            "LAST_NAME TEXT,"
            "MATIERE TEXT"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS students_teachers("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "STUDENT_ID TEXT NOT NULL,"
            "TEACHER_ID TEXT NOT NULL"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS messages("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SENDER_ID TEXT ,"
            "MESSAGE TEXT ,"
            "SUBJECT TEXT,"
            "DATE STRING ,"
            "TIME STRING ,"
            "APPROVED INT,"
            "SERVER_ID TEXT UNIQUE,"
            "SEEN INTEGER DEFAULT 0,"
            "RECEIVER_ID TEXT,"
            "DOWNLOADED INT,"
            "FILES TEXT"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS notifications("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "SERVER_ID TEXT UNIQUE ,"
            "CLASS_ID TEXT ,"
            "RECEIVER TEXT ,"
            "APPROVED INT ,"
            "DATE STRING ,"
            "SEEN INT ,"
            "USER_ID ,"
            "NEW INTEGER DEFAULT 1,"
            "MESSAGE TEXT ,"
            "TITLE TEXT ,"
            "FROM_ TEXT ,"
            "DOWNLOADED INT,"
            "FILES TEXT"
            " );");
        await database.execute("CREATE TABLE IF NOT EXISTS downloads("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "DATE DATETIME,"
            "PATH TEXT,"
            "TYPE TEXT," //notification or messages
            "EXTENSION TEXT,"
            "NAME TEXT,"
            "URL TEXT, "
            "OWNER STRING ,"
            "DOWNLOADED INT"
            ");");
        await database.execute("CREATE TABLE IF NOT EXISTS settings("
            "ID INTEGER PRIMARY KEY AUTOINCREMENT,"
            "CONFIG TEXT NOT NULL,"
            "VALUE TEXT DEFAULT 0"
            ");");
      },
    );
  }

  Future<int> insert({String tableName, Map<String, dynamic> values}) async {
    if (db.isOpen) {
      return await db.insert(tableName, values);
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
      int offset,
      String orderBy}) async {
    if (db == null) await prepareDB();

    if (db.isOpen) {
      return await db.query(
        tableName,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        distinct: distinct,
        groupBy: groupBy,
        having: having,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
      );
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

  Future<int> countTableRows({@required String tableName}) async {
    if (db.isOpen) {
      final List<Map<String, dynamic>> result =
          await db.query(tableName, columns: ["COUNT(*) as number"]);
      return result.isNotEmpty ? result.first["number"] : 0;
    }
    return 0;
  }
}
