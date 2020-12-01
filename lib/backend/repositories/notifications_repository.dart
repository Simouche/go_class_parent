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
        await _remoteNotificationsProvider.loadNotifications(userServerID);
    _localNotificationsProvider.storeNotifications(serverNotifications);
    return serverNotifications;
  }

  Future<List<Notification>> loadNotificationsFromDB() =>
      _localNotificationsProvider.loadNotifications("");
}
