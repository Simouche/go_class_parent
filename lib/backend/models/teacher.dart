import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Teacher extends Equatable {
  final String firstName, lastName, serverID, matiere;
  static const String TABLE_NAME = "teachers";

  Teacher({this.firstName, this.lastName, this.serverID, this.matiere});

  static Teacher fromJson(Map json) {
    return Teacher(
        serverID: json['_id'],
        firstName: json['firstNameFr'],
        lastName: json['lastNameFr'],
        matiere: json['matiere']);
  }

  static Teacher fromDB(Map<String, dynamic> row) {
    return Teacher(
      firstName: row["FIRST_NAME"],
      lastName: row["LAST_NAME"],
      matiere: row["MATIERE"],
      serverID: row["SERVER_ID"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "FIRST_NAME": firstName,
      "LAST_NAME": lastName,
      "MATIERE": matiere,
      "SERVER_ID": serverID,
    };
  }

  static Future<List<Teacher>> getAllFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
        tableName: TABLE_NAME, columns: ["*"], orderBy: 'ID');
    final List<Teacher> directors = List();
    results.forEach((element) => directors.add(fromDB(element)));
    return directors;
  }

  static Future<Teacher> getTeacher(LocalDB database, String teacherID) async {
    final List<Map<String, dynamic>> result = await database.query(
        tableName: TABLE_NAME,
        columns: ["*"],
        where: "SERVER_ID = ?",
        whereArgs: [teacherID]);
    return fromDB(result.first);
  }

  static Future<List<Teacher>> getTeachersByIDs(
      LocalDB database, List<String> ids) async {
    final List<Map<String, dynamic>> results = await database.query(
      tableName: TABLE_NAME,
      columns: ["*"],
      where: "SERVER_ID IN ('" + ids.join("','") + "')",
    );
    final List<Teacher> teachers =
        results.map<Teacher>((element) => fromDB(element)).toList();
    return teachers;
  }

  Future<bool> saveToDB(LocalDB database) async {
    try {
      final int result =
          await database.insert(tableName: TABLE_NAME, values: toMap());
      log("finished inserting TEACHER $serverID into the DB");
      return result > 0;
    } catch (e) {
      log("duplicate of $serverID");
      return false;
    }
  }

  @override
  List<Object> get props => [firstName, lastName, serverID, matiere];

  @override
  String toString() => "$lastName $firstName";
}
