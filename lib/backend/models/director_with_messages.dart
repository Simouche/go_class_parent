import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'director.dart';
import 'message.dart';

class DirectorWithMessages extends Equatable {
  final Director director;
  final List<Message> messages;

  DirectorWithMessages({this.director, this.messages});

  static List<DirectorWithMessages> filterDirectorWithMessages(
      {List<Director> directors, List<Message> messages}) {
    final List<DirectorWithMessages> directorWithMessage = List();
    directors.forEach((element) {
      directorWithMessage.add(DirectorWithMessages(
          director: element,
          messages: messages
              .where((message) =>
                  message.senderId == element.serverID ||
                  message.receiverId == element.serverID)
              .toList()));
    });
    return directorWithMessage;
  }

  static Future<DirectorWithMessages> getTeacherWithMessages(
      LocalDB database, String directorID) async {
    final Director director = await Director.getDirector(database, directorID);
    final List<Message> messages =
        await Message.getConversation(database, directorID);
    return DirectorWithMessages(director: director, messages: messages);
  }

  @override
  List<Object> get props => [director, messages];

  @override
  String toString() => "$director";
}
