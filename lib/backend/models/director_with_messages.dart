import 'package:equatable/equatable.dart';

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

  @override
  List<Object> get props => [director, messages];

  @override
  String toString() => "$director";
}
