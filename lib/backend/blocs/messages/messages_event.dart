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
  final String contactID;
  final int type;

  OpenConversationEvent({this.contactID,this.type});

  @override
  List<Object> get props => [contactID,this.type];
}

class OpenNewMessageEvent extends MessagesEvent {
  final String contactID;

  OpenNewMessageEvent({this.contactID});

  @override
  List<Object> get props => [contactID];
}
