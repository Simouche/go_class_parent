import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/with_messages_mixin.dart';

import 'message.dart';
import 'teacher.dart';

class TeacherWithMessages extends Equatable implements WithMessagesMixin {
  final Teacher teacher;
  final List<Message> messages;

  TeacherWithMessages({this.teacher, this.messages});

  static List<TeacherWithMessages> filterTeachersWithMessages(
      {List<Teacher> teachers, List<Message> messages}) {
    final List<TeacherWithMessages> teachersWithMessages = List();
    teachers.forEach(
      (teacher) {
        final List<Message> tempMessages = List();
        messages.forEach(
          (message) {
            if (message.senderId == teacher.serverID ||
                message.receiverId == teacher.serverID) {
              tempMessages.add(message);
            }
          },
        );
        if (!teachersWithMessages.contains(
            TeacherWithMessages(teacher: teacher, messages: tempMessages))) {
          teachersWithMessages.add(
              TeacherWithMessages(teacher: teacher, messages: tempMessages));
        }
      },
    );
    return teachersWithMessages;
  }

  static Future<TeacherWithMessages> getTeacherWithMessages(
      LocalDB database, String teacherID) async {
    final Teacher teacher = await Teacher.getTeacher(database, teacherID);
    final List<Message> messages =
        await Message.getConversation(database, teacherID);
    return TeacherWithMessages(teacher: teacher, messages: messages);
  }

  static Future<List<TeacherWithMessages>> getAllTeachersWithMessages(
      LocalDB database) async {
    final List<TeacherWithMessages> teachersWithMessages = List();

    for (Teacher teacher in (await Teacher.getAllFromDB(database))) {
      final TeacherWithMessages teacherWithMessages =
          await getTeacherWithMessages(database, teacher.serverID);
      if (teacherWithMessages.messages.isNotEmpty)
        teachersWithMessages.add(teacherWithMessages);
    }
    return teachersWithMessages;
  }

  @override
  List<Object> get props => [teacher, messages];

  @override
  String toString() => teacher.serverID;

  @override
  String getName() => teacher.toString();

  @override
  int getType() => 3;

  @override
  int length() => messages.length;

  @override
  List<Message> getMessages() => messages;
}
