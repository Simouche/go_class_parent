import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class MessagingRepository {
  final RemoteMessagesProvider _remoteMessagesProvider =
      RemoteMessagesProvider();

  Future<List<dynamic>> loadMessages(String currentUserID) async =>
      _remoteMessagesProvider.loadMessages(currentUserID);

  Future<bool> sendMessage(Message message) async {
    return _remoteMessagesProvider.sendMessage(message);
  }
}
