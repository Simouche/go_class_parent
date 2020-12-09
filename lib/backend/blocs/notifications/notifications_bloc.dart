import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/notification.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsLoading());

  final NotificationsRepository _notificationsRepository =
      NotificationsRepository();

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    switch (event.runtimeType) {
      case LoadNotificationEvent:
        yield* mapNotificationsLoadingToState(
            (event as LoadNotificationEvent).userServerID);
        break;
    }
  }

  Stream<NotificationsState> mapNotificationsLoadingToState(
      String userServerID) async* {
    yield NotificationsLoading();
    try {
      print("loading notifications for $userServerID");
      List<Notification> notifications =
          await _notificationsRepository.loadNotificationsFromDB();

      yield NotificationsLoaded(notifications: notifications);
      print("Loaded ${notifications.length} notifications from DB");

      final List<Notification> serverNotifications =
          await _notificationsRepository.loadNotificationsFromServer(
              userServerID,
              notifications.isNotEmpty ? notifications.first.serverId : "");
      log("${serverNotifications.length} loaded from server");

      notifications = serverNotifications + notifications;
      print("Loaded ${notifications.length} notifications from DB and Server");
      yield NewNotificationsCountState(count: serverNotifications.length);
      yield NotificationsLoaded(notifications: notifications);

    } catch (e, stacktrace) {
      log(e.toString());
      print(stacktrace);
      yield NotificationsLoadingFailed();
    }
  }
}
