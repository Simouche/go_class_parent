import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class MessagingRepository {
  final RemoteMessagesProvider _remoteMessagesProvider =
      RemoteMessagesProvider();
  final LocalMessagesProvider _localMessagesProvider = LocalMessagesProvider();
  final SynchronizationProvider _synchronizationProvider =
      SynchronizationProvider();

  Future<List<Message>> loadMessagesRemotely(String currentUserID) async {
    final List<Message> messages =
        await _remoteMessagesProvider.loadMessages(currentUserID);
    _localMessagesProvider.storeMessages(messages);
    return messages;
  }

  Future<List<Message>> loadMessagesFromDB() async {
    return await _localMessagesProvider.loadMessages("");
  }

  Future<bool> sendMessage(Message message) async {
    return _remoteMessagesProvider.sendMessage(message);
  }

  Future<CEO> getCEO() async {
    return await _synchronizationProvider.getCEO();
  }

  Future<CeoWithMessages> getCEOWithMessages() async {
    return await _localMessagesProvider.getCeoWithMessages();
  }

  Future<TeacherWithMessages> getTeacherWithMessages(String teacherID) async {
    return await _localMessagesProvider.getTeacherWithMessages(teacherID);
  }

  Future<DirectorWithMessages> getDirectorWithMessages(
      String directorID) async {
    return await _localMessagesProvider.getDirectorWithMessages(directorID);
  }

  Future<StudentWithDirectorAndTeachers> getStudentWithDirectorAndTeachers(
      String studentID) async {
    return await _synchronizationProvider.getAllAboutStudent(studentID);
  }

  Future<List<StudentWithDirectorAndTeachers>> getAllAboutAllStudents() async {
    return await _synchronizationProvider.getAllAboutAllStudents();
  }

  Future<List<dynamic>> getAllConversation() async =>
      await _localMessagesProvider.loadConversations();

  Future<int> newMessagesCount() async {
    return await _localMessagesProvider.getNewMessagesCount();
  }
}
