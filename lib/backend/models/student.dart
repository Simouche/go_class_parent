import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Student extends Equatable {
  final String serverID, firstName, lastName;

  Student({this.serverID, this.firstName, this.lastName});

  static Student fromJson(Map json) {
    return Student(
        serverID: json['_id'],
        firstName: json['firstNameFr'],
        lastName: json['lastNameFr']);
  }

  static Future<int> insert(LocalDB database, Map json) async {
    return 0;
  }

  @override
  String toString() => "$lastName $firstName";

  @override
  List<Object> get props => [serverID, firstName, lastName];
}
