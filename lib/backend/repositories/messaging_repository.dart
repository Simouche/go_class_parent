import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class MessagingRepository {
  final RemoteMessagesProvider _remoteMessagesProvider =
      RemoteMessagesProvider();
  final LocalMessagesProvider _localMessagesProvider = LocalMessagesProvider();

  Future<List<Message>> loadMessages(String currentUserID,
          {String lastMessageID}) async =>
      _remoteMessagesProvider.loadMessages(currentUserID,
          lastMessageID: lastMessageID);

  Future<List<Message>> loadMessagesFromDB() async {
    return await _localMessagesProvider.loadMessages("");
  }

  Future<bool> sendMessage(Message message) async {
    return _remoteMessagesProvider.sendMessage(message);
  }
}
