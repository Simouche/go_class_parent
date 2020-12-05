import 'package:go_class_parent/backend/db/local_db.dart';

class Settings {
  static String tableName = "settings";

  static const String CONFIG_COL = "CONFIG";
  static const String VALUE_COL = "VALUE";
  static const String NOTIFICATION_TOKEN_CONFIG = "notification_token";
  static const String CUSTOM_DOMAIN_CONFIG = "custom_domain";
  static const String LAST_MESSAGES_SYNC = "last_messages_sync";
  static const String SYNCED = "synced";

  static const String whereStatement = "CONFIG = ?";

  static Future<bool> tokenIsSet(LocalDB database) async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: tableName,
        columns: ["*"],
        where: whereStatement,
        whereArgs: [NOTIFICATION_TOKEN_CONFIG]);
    return result.isNotEmpty && result[0]['VALUE'] != 0;
  }

  static Future<bool> setToken(LocalDB database) async {
    int result = await database.insert(
        tableName: tableName,
        values: {CONFIG_COL: NOTIFICATION_TOKEN_CONFIG, VALUE_COL: 1});
    return result != 0;
  }

  static Future<String> usesCustomDomain(LocalDB database) async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: tableName,
        columns: ['*'],
        where: whereStatement,
        whereArgs: [CUSTOM_DOMAIN_CONFIG]);
    return result.isNotEmpty ? (result[0]['VALUE'] as String) : "";
  }

  static Future<bool> setCustomDomain(
      LocalDB database, String customDomain) async {
    int result = await database.insert(
        tableName: tableName,
        values: {CONFIG_COL: CUSTOM_DOMAIN_CONFIG, VALUE_COL: customDomain});
    return result != 0;
  }

  static Future<bool> hasSynced(LocalDB database) async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: tableName,
        columns: ["*"],
        where: whereStatement,
        whereArgs: [SYNCED]);
    return result.isNotEmpty;
  }

  static Future<void> setSynced(LocalDB database) async {
    await database.insert(tableName: tableName, values: {
      CONFIG_COL: SYNCED,
      VALUE_COL: DateTime.now().toIso8601String()
    });
  }

  static Future<String> getLastMessagesSync(LocalDB database) async {}
}
