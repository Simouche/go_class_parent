import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';

import 'base_providers.dart';

class RemoteNotificationsProvider extends BaseNotificationsProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  int _offset;

  @override
  Future<List<Notification>> loadNotifications(String userServerID) async {
    final response = await client
        .get("get-all-notifications", queries: {'user_id': userServerID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        print(json['data']);
        final List<Notification> notifications = List();
        json['data']['notifications'].forEach((element) {
          notifications.add(Notification.fromJson(element));
        });
        return notifications;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<bool> storeNotifications() {
    // TODO: implement storeNotifications
    throw UnimplementedError();
  }

  set offset(int offset) => _offset = offset;
}
