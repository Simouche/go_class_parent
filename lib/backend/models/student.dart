import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Student extends Equatable {
  final String serverID, firstName, lastName, state, director;
  static const TABLE_NAME = "students";
  final int id;

  Student(
      {this.id,
      this.director,
      this.state,
      this.serverID,
      this.firstName,
      this.lastName});

  static Student fromJson(Map json) {
    return Student(
      serverID: json['_id'],
      firstName: json['firstNameFr'],
      lastName: json['lastNameFr'],
      state: json['state'],
      director: json['director']
    );
  }

  static Student fromDB(Map<String, dynamic> row) {
    return Student(
      id: row["ID"],
      serverID: row["SERVER_ID"],
      firstName: row["FIRST_NAME"],
      lastName: row["LAST_NAME"],
      state: row["STATE"],
      director: row["DIRECTOR"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "SERVER_ID": serverID,
      "FIRST_NAME": firstName,
      "LAST_NAME": lastName,
      "STATE": state,
      "DIRECTOR": director,
    };
  }

  static Future<List<Student>> getAllFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
        tableName: TABLE_NAME, columns: ["*"], orderBy: 'ID');
    final List<Student> directors = List();
    results.forEach((element) => directors.add(fromDB(element)));
    return directors;
  }

  Future<bool> saveToDB(LocalDB db) async {
    log("starting to save to the db");
    final int result = await db.insert(tableName: TABLE_NAME, values: toMap());
    log("finished inserting into the DB");
    return result > 0;
  }

  static Future<Student> getStudent(
      LocalDB database, String studentID) async {
    final List<Map<String, dynamic>> result = await database.query(
        tableName: TABLE_NAME,
        columns: ["*"],
        where: "SERVER_ID = ?",
        whereArgs: [studentID]);
    return fromDB(result.first);
  }

  @override
  String toString() => "$lastName $firstName";

  @override
  List<Object> get props => [serverID, firstName, lastName];
}
