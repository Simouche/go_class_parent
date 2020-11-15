import 'package:equatable/equatable.dart';

import '../db/local_db.dart';

class Parent extends Equatable {
  final int id;
  final String firstName, lastName, phone, personalID, email, serverId, code;

  Parent({
    this.code,
    this.id,
    this.serverId,
    this.firstName,
    this.lastName,
    this.phone,
    this.personalID,
    this.email,
  });

  static Future<int> insertParentFromJson(LocalDB database, Map json) async {
    if (json['data']['parent'] == null) return 0;
    final int rows = await database.insert(tableName: "parents", values: {
      "FIRST_NAME": json['data']['parent']['firstNameFr'],
      "LAST_NAME": json['data']['parent']['lastNameFr'],
      "PHONE": json['data']['parent']['personalID'],
      "SERVER_ID": json['data']['parent']['_id'],
      "PERSONAL_ID": json['data']['parent']['personalID'],
      "EMAIL": json['data']['parent']['email'],
      "CODE": json['data']['parent']['authentication']['code'],
    });
    return rows;
  }

  static Future<Parent> getCurrentParent(LocalDB database) async {
    List<Map<String, dynamic>> result =
        await database.query(tableName: "parents", columns: ["*"]);
    if (result != null && result.isNotEmpty) {
      print('there is a result');
      return Parent(
          id: result[0]['ID'],
          firstName: result[0]['FIRST_NAME'],
          lastName: result[0]['LAST_NAME'],
          phone: result[0]['PHONE'],
          serverId: result[0]['SERVER_ID'],
          personalID: result[0]['PERSONAL_ID'],
          email: result[0]['EMAIL']);
    }
    return null;
  }

  @override
  List<Object> get props => [id, firstName, lastName, phone, personalID, email];
}
