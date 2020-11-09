import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class NotificationsRepository {
  final RemoteNotificationsProvider _remoteNotificationsProvider =
      RemoteNotificationsProvider();

  Future<List<Notification>> loadNotifications(String userServerID) async =>
      _remoteNotificationsProvider.loadNotifications(userServerID);
}
