import 'dart:ffi';

import 'package:go_class_parent/backend/models/models.dart';

abstract class BaseAuthenticationProvider {
  Future<User> signIn();

  Future<Void> signOut();

  Future<User> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<bool> checkCode();

  Future<bool> checkResetCode();

  Future<bool> register();

  Future<Parent> getCurrentParent();

  Future<String> resetPassword(String code);

  Future<bool> changePassword(String password, String userID);

  logout();
}

abstract class BaseUserDataProvider {}

abstract class BaseNotificationsProvider {
  Future<List<Notification>> loadNotifications(String userServerID);

  Future<bool> storeNotifications(List<Notification> notifications);
}

abstract class BaseMessagingProvider {
  Future<List<Message>> loadMessages(String currentUserID);

  Future<bool> storeMessages(List<Message> messages);

  Future<bool> sendMessage(Message message);

  Future<List<Message>> loadConversation(String contact);
}

abstract class BaseDownloadsProvider {
  Future<bool> downloadFiles(List<dynamic> urls);

  Future<List<AttachmentFile>> loadFilesFromDB();
}

abstract class BaseSynchronizationProvider {
  Future<bool> loadInitialData(String userID);
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

abstract class BaseStudentProvider {
  Future<List<Student>> getStudents(String parentID);

  Future<bool> requestStudentsPermission(String parent, List<String> students);
}

abstract class BaseAttendanceProvider {
  Future<List<Attendance>> loadAttendance(String childID);
}
