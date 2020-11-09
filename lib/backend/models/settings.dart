import 'package:go_class_parent/backend/db/local_db.dart';

class Settings {
  static String tableName = "settings";

  static final String configCol = "CONFIG";
  static final String valueCol = "VALUE";
  static final String notificationTokenConfig = "notification_token";
  static final String customDomainConfig = "custom_domain";
  static final String whereStatement = "CONFIG=?";

  static Future<bool> tokenIsSet(LocalDB database) async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: tableName,
        columns: ["*"],
        where: whereStatement,
        whereArgs: [notificationTokenConfig]);
    return result.isNotEmpty && result[0]['VALUE'] != 0;
  }

  static Future<bool> setToken(LocalDB database) async {
    int result = await database.insert(
        tableName: tableName,
        values: {configCol: notificationTokenConfig, valueCol: 1});
    return result != 0;
  }

  static Future<String> usesCustomDomain(LocalDB database) async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: tableName,
        columns: ['*'],
        where: whereStatement,
        whereArgs: [customDomainConfig]);
    return result.isNotEmpty ? (result[0]['VALUE'] as String) : "";
  }

  static Future<bool> setCustomDomain(
      LocalDB database, String customDomain) async {
    int result = await database.insert(
        tableName: tableName,
        values: {configCol: customDomainConfig, valueCol: customDomain});
    return result != 0;
  }
}
