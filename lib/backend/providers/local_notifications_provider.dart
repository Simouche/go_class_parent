import 'dart:developer';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/notification.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';

class LocalNotificationsProvider extends BaseNotificationsProvider {
  final LocalDB database = LocalDB();

  @override
  Future<List<Notification>> loadNotifications(String userServerID) async {
    return await Notification.getAllFromDB(database);
  }

  @override
  Future<bool> storeNotifications(List<Notification> notifications) async {
    for (Notification e in notifications) {
      log("saving Notification ${e.serverId} to db");
      await e.saveToDB(database);
      log("finished saving Notification ${e.serverId} to db");
    }
    return true;
  }
}
