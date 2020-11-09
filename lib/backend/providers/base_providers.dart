import 'dart:ffi';

import 'package:go_class_parent/backend/models/models.dart';

abstract class BaseAuthenticationProvider {
  Future<User> signIn();

  Future<Void> signOut();

  Future<User> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<bool> checkCode();

  Future<bool> register();

  Future<Parent> getCurrentParent();
}

abstract class BaseUserDataProvider {}

abstract class BaseNotificationsProvider {
  Future<List<Notification>> loadNotifications(String userServerID);

  Future<bool> storeNotifications();
}

abstract class BaseMessagingProvider {
  Future<List<dynamic>> loadMessages(String currentUserID);

  Future<bool> storeMessages();

  Future<bool> sendMessage(Message message);

  Future<List<Message>> loadConversation();
}

abstract class BaseDownloadsProvider {
  Future<bool> downloadFiles(List<dynamic> urls);

  Future<List<AttachmentFile>> loadFilesFromDB();
}

abstract class BaseSettingsProvider {}

abstract class BaseSchedulesProvider {
  Future<Map<String, dynamic>> loadSchedules(String userID);
}

abstract class BasePaymentProvider {
  Future<Map<String, List<Payment>>> loadPayments(String currentUserID);
}

abstract class BaseCanteenProvider {
  Future<List<Canteen>> loadCanteen(String currentUserID);
}
