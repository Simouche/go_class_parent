part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {}

class AuthenticationUnknown extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticating extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationFailed extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RegistrationCodeValid extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RegistrationCodeInvalid extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RegistrationSuccess extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RegistrationFail extends AuthenticationState {
  @override
  List<Object> get props => [];
}
