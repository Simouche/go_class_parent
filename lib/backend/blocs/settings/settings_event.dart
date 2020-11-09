part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {}

class CheckNotificationsToken extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SetNotificationToken extends SettingsEvent {
  @override
  List<Object> get props => [];
}
