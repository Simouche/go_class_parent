import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

import 'base_providers.dart';

class RemoteMessagesProvider extends BaseMessagingProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();
  final SettingsProvider _settingsProvider = SettingsProvider();

  int _offset;

  @override
  Future<List<Message>> loadConversation(String contact) async {
    final List<Message> messages =
        await Message.getConversation(database, contact);
    return messages;
  }

  @override
  Future<List<Message>> loadMessages(String currentUserID) async {
    final String lastMessageID = await Message.getLastMessageID(database);
    final response = await client.get('get-all-messages',
        queries: {'user_id': currentUserID, "lastMessageID": lastMessageID});
    final status = handleHttpCode(response.statusCode);
    final List<Message> messages = List();
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        json['data']['messages']
            .forEach((element) => messages.add(Message.fromJson(element)));
        return messages;
      } else {
        return List<Message>();
      }
    }
    return List<Message>();
  }

  @override
  Future<bool> sendMessage(Message message) async {
    final response = await client.post('send-message', message.toJson());
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      return !json['error'];
    }
    return false;
  }

  @override
  Future<bool> storeMessages(List<Message> messages) {
    // TODO: implement storeMessages
    throw UnimplementedError();
  }

  set offset(int offset) => _offset = offset;

  @override
  Future<CeoWithMessages> getCeoWithMessages() {
    // TODO: implement getCeoWithMessages
    throw UnimplementedError();
  }

  @override
  Future<List> loadConversations() {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }
}
