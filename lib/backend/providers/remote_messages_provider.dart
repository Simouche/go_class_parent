import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';

import 'base_providers.dart';

class RemoteMessagesProvider extends BaseMessagingProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  int _offset;

  @override
  Future<List<Message>> loadConversation() {
    // TODO: implement loadConversation
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> loadMessages(String currentUserID) async {
    final response = await client
        .get('get-all-messages', queries: {'user_id': currentUserID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final List<Message> messages = List();
        final List<StudentWithTeachersAndMatieres>
            studentWithTeachersAndMatieres = List();
        json['data']['messages']
            .forEach((element) => messages.add(Message.fromJson(element)));
        json['data']['children'].forEach((element) {
          final Student student = Student.fromJson(element["child"]);
          final List<TeacherAndMatiere> teacherAndMatiere = List();
          element['teachers']?.forEach(
            (element) => teacherAndMatiere.add(
              TeacherAndMatiere(
                teacher: Teacher.fromJson(element[0]),
                matiere: Matiere.fromJson(element[1]),
              ),
            ),
          );
          studentWithTeachersAndMatieres.add(
            StudentWithTeachersAndMatieres(
              student: student,
              teacherAndMatiere: teacherAndMatiere,
              director: Director.fromJson(element['director']),
            ),
          );
        });
        final CEO ceo = CEO.fromJson(json['data']['ceo']);
        return <dynamic>[messages, studentWithTeachersAndMatieres, ceo];
      } else {
        return null;
      }
    } else {
      return null;
    }
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
  Future<bool> storeMessages() {
    // TODO: implement storeMessages
    throw UnimplementedError();
  }

  set offset(int offset) => _offset = offset;
}
