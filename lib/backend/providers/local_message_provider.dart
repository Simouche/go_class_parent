import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';

class LocalMessagesProvider extends BaseMessagingProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();

  @override
  Future<List<Message>> loadConversation(String contact) async {
    return await Message.getConversation(database, contact);
  }

  @override
  Future<List<Message>> loadMessages(String currentUserID) {
    // TODO: implement loadMessages
    throw UnimplementedError();
  }

  @override
  Future<bool> sendMessage(Message message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<bool> storeMessages(List<Message> messages) async {
    messages.forEach((element) => element.saveToDB(database));
    return true;
  }
}
