part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {}

class LoginSubmitted extends AuthenticationEvent {
  final String username, password;

  LoginSubmitted(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class CodeConfirmationSubmitted extends AuthenticationEvent {
  CodeConfirmationSubmitted(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class RegistrationSubmitted extends AuthenticationEvent {
  final String username, password, code;

  RegistrationSubmitted(this.username, this.password, this.code);

  @override
  List<Object> get props => [username, password, code];
}

class AppLaunched extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class CheckResetPasswordCodeEvent extends AuthenticationEvent {
  final String code;

  CheckResetPasswordCodeEvent({this.code});

  @override
  List<Object> get props => [code];
}

class SetNewPasswordEvent extends AuthenticationEvent {
  final String password;
  final String userID;

  SetNewPasswordEvent({this.password, this.userID});

  @override
  List<Object> get props => [password, userID];
}
