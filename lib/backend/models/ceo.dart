import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class CEO extends Equatable {
  final String name, email, phone, serverID;
  static const String TABLE_NAME = "ceo";

  const CEO({this.name, this.email, this.phone, this.serverID});

  @override
  List<Object> get props => [name, email, phone, serverID];

  @override
  String toString() => '$name';

  static CEO fromJson(Map json) {
    return CEO(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      serverID: json['_id'] ?? json['validateUserId'],
    );
  }

  static CEO fromDB(Map<String, dynamic> row) {
    return CEO(
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

  static Future<CEO> getCEOFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results =
        await database.query(tableName: TABLE_NAME, columns: ["*"], limit: 1);
    return results.isNotEmpty ? CEO.fromDB(results.first) : null;
  }

  Future<bool> saveToDB(LocalDB database) async {
    if (await database.countTableRows(tableName: TABLE_NAME) > 0) return true;
    final int result = await database.insert(tableName: TABLE_NAME, values: toMap());
    log("finished inserting into the DB");
    return result > 0;
  }
}
