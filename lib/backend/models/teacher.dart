import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Teacher extends Equatable {
  final String firstName, lastName, serverID, matiere;

  Teacher({this.firstName, this.lastName, this.serverID, this.matiere});

  static Teacher fromJson(Map json) {
    return Teacher(
        serverID: json['_id'],
        firstName: json['firstNameFr'],
        lastName: json['lastNameFr'],
        matiere: json['matiere']);
  }

  static Future<int> insert(LocalDB database, json) async {
    //TODO Insert teacher into DB
  }

  @override
  List<Object> get props => [firstName, lastName, serverID, matiere];

  @override
  String toString() => "Mr $lastName $firstName";
}
