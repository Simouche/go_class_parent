import 'package:go_class_parent/backend/providers/providers.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

class SynchronizationRepository {
  final SynchronizationProvider provider = SynchronizationProvider();
  final SettingsRepository settings = SettingsRepository();
  final RemoteMessagesProvider _messagesProvider = RemoteMessagesProvider();
  final MessagingRepository _messagingRepository = MessagingRepository();

  Future<bool> loadInitialData(String userID) async {
    await _messagingRepository.loadMessagesRemotely(userID);
    if (!(await settings.hasSynced()))
      return await provider.loadInitialData(userID);
    return true;
  }
}
