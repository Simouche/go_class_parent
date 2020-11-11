import 'package:equatable/equatable.dart';

class CEO extends Equatable {
  final String name, email, phone, serverID;

  const CEO({this.name, this.email, this.phone, this.serverID});

  @override
  List<Object> get props => [name, email, phone, serverID];

  @override
  String toString() => 'Mr $name';

  static CEO fromJson(Map json) {
    return CEO(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      serverID: json['_id'] ?? json['validateUserId'],
    );
  }
}
