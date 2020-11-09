part of 'messages_bloc.dart';

@immutable
abstract class MessagesState extends Equatable {}

class MessagesLoading extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessagesLoaded extends MessagesState {
  final List<dynamic> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ConversationLoaded extends MessagesState {
  final List<Message> messages;

  ConversationLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ConversationLoadingFailed extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessagesLoadingFailed extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessageSending extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessageSendFailed extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessageSent extends MessagesState {
  @override
  List<Object> get props => [];
}

class OpenConversationState extends MessagesState {
  final TeacherWithMessages teacher;
  final DirectorWithMessages director;
  final CeoWithMessages ceo;

  OpenConversationState({this.ceo, this.teacher, this.director});

  @override
  List<Object> get props => [teacher];
}

class OpenNewMessageState extends MessagesState {
  final Teacher teacher;
  final Director director;
  final CEO ceo;

  OpenNewMessageState({this.ceo, this.teacher, this.director});

  @override
  List<Object> get props => [teacher];
}
