part of 'messages_bloc.dart';

@immutable
abstract class MessagesEvent extends Equatable {}

class LoadMessagesEvent extends MessagesEvent {
  final String currentUserID;

  LoadMessagesEvent(this.currentUserID);

  @override
  List<Object> get props => [currentUserID];
}

class LoadConversationEvent extends MessagesEvent {
  final String contactId;

  LoadConversationEvent(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class SendMessageEvent extends MessagesEvent {
  final Message message;

  SendMessageEvent(this.message);

  @override
  List<Object> get props => [];
}

class OpenConversationEvent extends MessagesEvent {
  final TeacherWithMessages teacher;
  final DirectorWithMessages director;
  final CeoWithMessages ceo;

  OpenConversationEvent({this.ceo, this.teacher, this.director});

  @override
  List<Object> get props => [teacher, director];
}

class OpenNewMessageEvent extends MessagesEvent {
  final Teacher teacher;
  final Director director;
  final CEO ceo;

  OpenNewMessageEvent({this.ceo, this.teacher, this.director});

  @override
  List<Object> get props => [teacher];
}
