import 'package:go_class_parent/backend/providers/providers.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

class SynchronizationRepository {
  final SynchronizationProvider provider = SynchronizationProvider();
  final SettingsRepository settings = SettingsRepository();

  Future<bool> loadInitialData(String userID) async {
    if (!(await settings.hasSynced()))
      return await provider.loadInitialData(userID);
    return true;
  }
}
