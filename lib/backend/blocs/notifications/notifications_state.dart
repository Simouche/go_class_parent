part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState extends Equatable {}

class NotificationsLoading extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NewNotificationsCountState extends NotificationsState {
  final int count;

  NewNotificationsCountState({this.count});

  @override
  List<Object> get props => [this.count];
}

class NotificationsLoaded extends NotificationsState {
  final List<Notification> notifications;

  NotificationsLoaded({this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsLoadingFailed extends NotificationsState {
  @override
  List<Object> get props => [];
}

class EmptyNotifications extends NotificationsState {
  @override
  List<Object> get props => [];
}
