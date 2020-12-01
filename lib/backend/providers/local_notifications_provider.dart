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
  Future<bool> storeNotifications(List<Notification> notifications) {
    notifications.map((e) => e
        .saveToDB(database)
        .catchError((onError) => print("error"))
        .whenComplete(() => true));
    return null;
  }
}
