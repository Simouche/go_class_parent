import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Student extends Equatable {
  final String serverID, firstName, lastName, state, director;
  static const TABLE_NAME = "students";
  final int id;
  final List<List<Note>> notes;

  Student({
    this.id,
    this.director,
    this.state,
    this.serverID,
    this.firstName,
    this.lastName,
    this.notes,
  });

  static Student fromJson(Map json) {
    return Student(
      serverID: json['_id'],
      firstName: json['firstNameFr'],
      lastName: json['lastNameFr'],
      state: "${json['state']}",
      director: json['director'],
      notes: (json['eval']['test'] as List).map<List<Note>>((element) {
        return (element as List).map((e) => Note.fromJson(e)).toList();
      }).toList(),
    );
  }

  static Student fromDB(Map<String, dynamic> row) {
    return Student(
      id: row["ID"],
      serverID: row["SERVER_ID"],
      firstName: row["FIRST_NAME"],
      lastName: row["LAST_NAME"],
      // state: row["STATE"],
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
    final List<Student> students = List();
    results.forEach((element) => students.add(fromDB(element)));
    return students;
  }

  Future<bool> saveToDB(LocalDB db) async {
    try {
      log("starting to save to the db");
      final int result =
          await db.insert(tableName: TABLE_NAME, values: toMap());
      log("finished inserting a The STUDENT $serverID into the DB");
      return result > 0;
    } catch (e) {
      log("duplicate of $serverID");
      return false;
    }
  }

  static Future<Student> getStudent(LocalDB database, String studentID) async {
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

class Note extends Equatable {
  final String mat, labelMatiere;
  final double d1, d2, ex;
  final bool stateD1, stateD2, stateEx;
  final int baremD1, baremD2, baremeEx;

  Note(
      {this.stateD1 = false,
      this.stateD2 = false,
      this.stateEx = false,
      this.labelMatiere,
      this.baremD1,
      this.baremD2,
      this.baremeEx,
      this.mat,
      this.d1,
      this.d2,
      this.ex});

  @override
  List<Object> get props => [this.mat, this.d1, this.d2, this.ex];

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      mat: json['idMatiere'],
      d1: double.parse(
          json['d1'].isNotEmpty ? (json['d1'] as String).split("/")[0] : "0"),
      baremD1: int.parse(
          json['d1'].isNotEmpty ? (json['d1'] as String).split("/")[1] : "0"),
      stateD1: json['stateD1'] ?? false,
      d2: double.parse(
          json['d2'].isNotEmpty ? (json['d2'] as String).split("/")[0] : "0"),
      baremD2: int.parse(
          json['d2'].isNotEmpty ? (json['d2'] as String).split("/")[1] : "0"),
      stateD2: json['stateD2'] ?? false,
      ex: double.parse((json['ex'] as String).isNotEmpty
          ? (json['ex'] as String).split("/")[0]
          : "0"),
      baremeEx: int.parse((json['ex'] as String).isNotEmpty
          ? (json['ex'] as String).split("/")[1]
          : "0"),
      stateEx: json['stateEx'] ?? false,
      labelMatiere: json['labelMatiere'],
    );
  }
}
