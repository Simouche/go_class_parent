import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'message.dart';
import 'teacher.dart';

class TeacherWithMessages extends Equatable {
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

  @override
  List<Object> get props => [teacher, messages];
}
