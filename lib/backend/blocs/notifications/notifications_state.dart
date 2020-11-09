part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState extends Equatable{}

class NotificationsLoading extends NotificationsState {
  @override
  List<Object> get props => [];
}

class NotificationsLoaded extends NotificationsState {
  final List<Notification> notifications;

  NotificationsLoaded({this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsLoadingFailed extends NotificationsState{
  @override
  List<Object> get props => [];
}

class EmptyNotifications extends NotificationsState{
  @override

  List<Object> get props => [];

}
