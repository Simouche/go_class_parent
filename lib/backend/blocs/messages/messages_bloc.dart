import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesLoading());

  final MessagingRepository _messagingRepository = MessagingRepository();

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    switch (event.runtimeType) {
      case LoadMessagesEvent:
        yield* mapMessagesLoadingToState(
            (event as LoadMessagesEvent).currentUserID);
        break;
      case SendMessageEvent:
        final SendMessageEvent sendMessageEvent = event;
        yield* mapSendMessagesToState(sendMessageEvent.message);
        break;
      case OpenConversationEvent:
        final OpenConversationEvent openConversationEvent = event;
        yield* mapOpenConversationEventToState(openConversationEvent.teacher,
            openConversationEvent.director, openConversationEvent.ceo);
        break;
      case OpenNewMessageEvent:
        final OpenNewMessageEvent openNewMessageEvent = event;
        yield OpenNewMessageState(
            teacher: openNewMessageEvent.teacher,
            director: openNewMessageEvent.director,
            ceo: openNewMessageEvent.ceo);
        break;
    }
  }

  Stream<MessagesState> mapMessagesLoadingToState(String currentUserID) async* {
    yield MessagesLoading();
    try {
      List<dynamic> messages =
          await _messagingRepository.loadMessages(currentUserID);
      yield MessagesLoaded(messages);
    } on Exception catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield MessagesLoadingFailed();
    }
  }

  Stream<MessagesState> mapSendMessagesToState(Message message) async* {
    yield MessageSending();
    try {
      final bool result = await _messagingRepository.sendMessage(message);
      yield result ? MessageSent() : MessageSendFailed();
    } catch (e, stacktrace) {
      yield MessageSendFailed();
      print(stacktrace);
    }
  }

  Stream<MessagesState> mapOpenConversationEventToState(
      TeacherWithMessages teacher,
      DirectorWithMessages director,
      CeoWithMessages ceo) async* {
    yield OpenConversationState(teacher: teacher, director: director, ceo: ceo);
  }
}
