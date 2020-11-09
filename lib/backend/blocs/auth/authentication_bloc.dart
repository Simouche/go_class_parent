import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository repository;
  String registrationCode;
  User _currentUser;
  Parent _currentParent;

  AuthenticationBloc({@required this.repository})
      : super(AuthenticationUnknown()) {
    _initialize();
  }

  void _initialize() async {
    if (_currentUser == null) {
      _currentUser = await repository.getCurrentUser();
    }
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AppLaunched:
        yield* mapAppLaunchedToState();
        break;
      case LoginSubmitted:
        LoginSubmitted eventCasted = event as LoginSubmitted;
        yield* mapLoginSubmitToState(
            Credentials(eventCasted.username, eventCasted.password));
        break;
      case CodeConfirmationSubmitted:
        CodeConfirmationSubmitted eventCasted =
            event as CodeConfirmationSubmitted;
        yield* mapRegistrationCodeSubmitToState(eventCasted.code);
        break;
      case RegistrationSubmitted:
        RegistrationSubmitted eventCasted = event as RegistrationSubmitted;
        yield* mapRegistrationToState(
            Credentials(eventCasted.username, eventCasted.password),
            eventCasted.code);
        break;
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
    yield Authenticating();
    if (await repository.isLoggedIn())
      yield Authenticated();
    else
      yield UnAuthenticated();
  }

  Stream<AuthenticationState> mapLoginSubmitToState(
      Credentials credentials) async* {
    yield Authenticating();
    User user =
        await repository.signIn(credentials.username, credentials.password);
    if (user != null) {
      yield Authenticated();
      _currentUser = user;
      repository.getCurrentParent().then((value) => _currentParent = value);
    } else
      yield AuthenticationFailed();
  }

  Stream<AuthenticationState> mapRegistrationCodeSubmitToState(
      String registrationCode) async* {
    yield Authenticating();
    bool status = false;
    try {
      status = await repository.checkCode(registrationCode);
    } on Exception catch (e) {
      yield RegistrationCodeInvalid();
      print(e);
    }
    if (status) {
      this.registrationCode = registrationCode;
      yield RegistrationCodeValid();
    } else {
      yield RegistrationCodeInvalid();
    }
  }

  Stream<AuthenticationState> mapRegistrationToState(
      Credentials credentials, String registrationCode) async* {
    yield Authenticating();
    try {
      bool status = await repository.register(
          credentials.username, credentials.password, registrationCode);
      yield status ? RegistrationSuccess() : RegistrationFail();
    } catch (e) {
      yield RegistrationFail();
      print(e);
    }
  }

  Future<Parent> get parent async {
    if (_currentParent == null) {
      _currentParent = await repository.getCurrentParent();
    }
    return _currentParent;
  }

  Parent get currentParent => _currentParent;

  User get currentUser {
    return _currentUser;
  }
}
