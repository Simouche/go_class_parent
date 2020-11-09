part of 'settings_bloc.dart';

@immutable
abstract class SettingsState extends Equatable {}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsNotificationTokenIsSetState extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsNotificationTokenIsNotSetState extends SettingsState {
  @override
  List<Object> get props => [];
}
