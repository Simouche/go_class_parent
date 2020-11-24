import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

class Student extends Equatable {
  final String serverID, firstName, lastName, state;

  Student({this.state, this.serverID, this.firstName, this.lastName});

  static Student fromJson(Map json) {
    return Student(
        serverID: json['student']['_id'],
        firstName: json['student']['firstNameFr'],
        lastName: json['student']['lastNameFr'],
        state: json['state'],);
  }

  static Future<int> insert(LocalDB database, Map json) async {
    return 0;
  }

  @override
  String toString() => "$lastName $firstName";

  @override
  List<Object> get props => [serverID, firstName, lastName];
}
