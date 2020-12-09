import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/with_messages_mixin.dart';

import 'director.dart';
import 'message.dart';

class DirectorWithMessages extends Equatable implements WithMessagesMixin {
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

  static Future<DirectorWithMessages> getDirectorWithMessages(
      LocalDB database, String directorID) async {
    final Director director = await Director.getDirector(database, directorID);
    final List<Message> messages =
        await Message.getConversation(database, directorID);
    return DirectorWithMessages(director: director, messages: messages);
  }

  static Future<List<DirectorWithMessages>> getAllDirectorsWithMessages(
      LocalDB database) async {
    final List<DirectorWithMessages> directorsWithMessages = List();

    for (Director director in (await Director.getAllFromDB(database))) {
      final DirectorWithMessages directorWithMessages =
          await getDirectorWithMessages(database, director.serverID);
      if (directorWithMessages.messages.isNotEmpty)
        directorsWithMessages.add(directorWithMessages);
    }
    return directorsWithMessages;
  }

  @override
  List<Object> get props => [director, messages];

  @override
  String toString() => director.serverID;

  @override
  String getName() => director.toString();

  @override
  int getType() => 2;

  @override
  int length() => messages.length;

  @override
  List<Message> getMessages() => messages;
}
