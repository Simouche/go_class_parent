import 'package:equatable/equatable.dart';

class Credentials extends Equatable{
  final String username, password;

  Credentials(this.username, this.password);

  @override
  List<Object> get props => [username,password];
}
