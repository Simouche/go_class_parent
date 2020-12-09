import 'dart:developer';

import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class NotificationsRepository {
  final RemoteNotificationsProvider _remoteNotificationsProvider =
      RemoteNotificationsProvider();
  final LocalNotificationsProvider _localNotificationsProvider =
      LocalNotificationsProvider();

  Future<List<Notification>> loadNotificationsFromServer(
      String userServerID, String lastNotificationID) async {
    final List<Notification> serverNotifications =
        await _remoteNotificationsProvider.loadNotifications(userServerID,
            lastNoticeID: lastNotificationID);
    log("loaded from server");
    _localNotificationsProvider
        .storeNotifications(serverNotifications)
        .catchError((onError) => log(onError.toString()))
        .whenComplete(() => log("completed storing notifications at the DB"));
    log("after storing notifications");
    return serverNotifications;
  }

  Future<List<Notification>> loadNotificationsFromDB() =>
      _localNotificationsProvider.loadNotifications("");
}
