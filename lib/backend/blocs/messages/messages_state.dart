part of 'messages_bloc.dart';

@immutable
abstract class MessagesState extends Equatable {}

class MessagesTransitionState extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessagesLoading extends MessagesState {
  @override
  List<Object> get props => [];
}

class MessagesLoaded extends MessagesState {
  final List<dynamic> conversations;
  final CEO ceo;
  final List<StudentWithDirectorAndTeachers> data;

  MessagesLoaded({this.conversations, this.ceo, this.data});

  @override
  List<Object> get props => [this.conversations, this.ceo, this.data];
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
  final WithMessagesMixin conversation;

  OpenConversationState({this.conversation});

  @override
  List<Object> get props => [this.conversation];
}

class OpenNewMessageState extends MessagesState {
  final Teacher teacher;
  final Director director;
  final CEO ceo;

  OpenNewMessageState({this.ceo, this.teacher, this.director});

  @override
  List<Object> get props => [teacher];
}
