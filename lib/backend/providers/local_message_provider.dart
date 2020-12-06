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

  Future<List<dynamic>> loadConversations() async {
    final List<dynamic> conversations = List();
    conversations.addAll(
        (await TeacherWithMessages.getAllTeachersWithMessages(database)));
    conversations.addAll(
        (await DirectorWithMessages.getAllDirectorsWithMessages(database)));

    final CeoWithMessages ceoWithMessages =
        (await CeoWithMessages.getCEOWithMessages(database));
    if (ceoWithMessages.messages.isNotEmpty) conversations.add(ceoWithMessages);

    conversations.sort((a, b) {
      if (a is WithMessagesMixin && b is WithMessagesMixin) if (a
              .getMessages()
              .last
              .id >
          b.getMessages().last.id)
        return 1;
      else
        return -1;
      else
        return 1;
    });
    return conversations;
  }

  Future<CeoWithMessages> getCeoWithMessages() async {
    return await CeoWithMessages.getCEOWithMessages(database);
  }

  Future<TeacherWithMessages> getTeacherWithMessages(String teacherID) async {
    return await TeacherWithMessages.getTeacherWithMessages(
        database, teacherID);
  }

  Future<DirectorWithMessages> getDirectorWithMessages(
      String directorID) async {
    return DirectorWithMessages.getDirectorWithMessages(database, directorID);
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
