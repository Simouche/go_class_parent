import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/models/models.dart';

import 'base_providers.dart';

class SettingsProvider extends BaseSettingsProvider {
  static final LocalDB database = LocalDB();

  Future<bool> tokenIsSet() async => Settings.tokenIsSet(database);

  Future<bool> setToken() async => Settings.setToken(database);

  Future<String> usesCustomDomain() async =>
      Settings.usesCustomDomain(database);

  Future<bool> setCustomDomain(String customDomain) async =>
      Settings.setCustomDomain(database, customDomain);

  static bool checkAndSetUpCustomDomain(json) {
    if (json['data']['domain'] != null && json['data']['domain'].isNotEmpty) {
      Settings.setCustomDomain(database, json['data']['domain']);
      HttpClient client = HttpClient();
      client.urls(json['data']['domain']);
      return true;
    }
    return false;
  }
}
