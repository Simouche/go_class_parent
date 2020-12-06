import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Director extends Equatable {
  final String name, phone, email, serverID;
  static const String TABLE_NAME = "directors";

  Director({this.name, this.phone, this.email, this.serverID});

  static Director fromJson(Map json) {
    return Director(
        name: json['Name'],
        email: json['email'],
        phone: json['phone'],
        serverID: json['_id']);
  }

  static Director fromDB(Map<String, dynamic> row) {
    return Director(
      name: row["NAME"],
      email: row["EMAIL"],
      phone: row["PHONE"],
      serverID: row["SERVER_ID"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "NAME": name,
      "EMAIL": email,
      "PHONE": phone,
      "SERVER_ID": serverID,
    };
  }

  static Future<List<Director>> getAllFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
        tableName: TABLE_NAME, columns: ["*"], orderBy: 'ID');
    final List<Director> directors = List();
    results.forEach((element) => directors.add(Director.fromDB(element)));
    return directors;
  }

  Future<bool> saveToDB(LocalDB db) async {
    log("starting to save to the db");
    final int result = await db.insert(tableName: TABLE_NAME, values: toMap());
    log("finished inserting a DIRECTOR into the DB");
    return result > 0;
  }

  static Future<Director> getDirector(
      LocalDB database, String directorID) async {
    final List<Map<String, dynamic>> result = await database.query(
        tableName: TABLE_NAME,
        columns: ["*"],
        where: "SERVER_ID = ?",
        whereArgs: [directorID]);
    return fromDB(result.first);
  }

  @override
  List<Object> get props => [name, phone, email, serverID];

  @override
  String toString() => "$name";
}
