import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());
  final SettingsRepository _repository = SettingsRepository();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    switch (event.runtimeType) {
      case CheckNotificationsToken:
        yield* mapCheckNotificationsTokenEventToState();
        break;
      case SetNotificationToken:
        yield* mapSetNotificationTokenEventToState();
        break;
    }
  }

  Stream<SettingsState> mapCheckNotificationsTokenEventToState() async* {
    bool result = await _repository.tokenIsSet();
    yield result
        ? SettingsNotificationTokenIsSetState()
        : SettingsNotificationTokenIsNotSetState();
  }

  Stream<SettingsState> mapSetNotificationTokenEventToState() async* {
    bool result = await _repository.setToken();
    yield result
        ? SettingsNotificationTokenIsSetState()
        : SettingsNotificationTokenIsNotSetState();
  }
}
