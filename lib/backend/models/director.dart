import 'package:equatable/equatable.dart';

class Director extends Equatable {
  final String name, phone, email, serverID;

  Director({this.name, this.phone, this.email, this.serverID});

  static Director fromJson(Map json) {
    return Director(
        name: json['Name'],
        email: json['email'],
        phone: json['phone'],
        serverID: json['_id']);
  }

  @override
  List<Object> get props => [name, phone, email, serverID];

  @override
  String toString() => "Mr $name";
}
