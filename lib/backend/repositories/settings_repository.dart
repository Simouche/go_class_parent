import 'package:go_class_parent/backend/providers/providers.dart';

class SettingsRepository {
  final SettingsProvider _provider = SettingsProvider();

  Future<bool> tokenIsSet() async => _provider.tokenIsSet();

  Future<bool> setToken() async => _provider.setToken();

  Future<String> usesCustomDomain() async => _provider.usesCustomDomain();

  Future<bool> setCustomDomain(String customDomain) async =>
      _provider.setCustomDomain(customDomain);

  Future<bool> hasSynced() async => _provider.getSynced();

  Future<void> setSynced() async => _provider.setSynced();
}
