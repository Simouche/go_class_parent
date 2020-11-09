import 'package:equatable/equatable.dart';

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

  @override
  List<Object> get props => [teacher, messages];
}
