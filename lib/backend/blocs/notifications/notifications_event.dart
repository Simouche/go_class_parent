part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsEvent extends Equatable {}

class LoadNotificationEvent extends NotificationsEvent {
  final String userServerID;

  LoadNotificationEvent(this.userServerID);

  @override
  List<Object> get props => [userServerID];
}

class NotificationClickedEvent extends NotificationsEvent {
  final Notification notification;

  NotificationClickedEvent(this.notification);

  @override
  List<Object> get props => [];
}
