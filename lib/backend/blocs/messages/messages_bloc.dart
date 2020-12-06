import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/models/with_messages_mixin.dart';
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
        yield* mapOpenConversationEventToState(
            openConversationEvent.contactID, openConversationEvent.type);
        break;
      case OpenNewMessageEvent:
        final OpenNewMessageEvent openNewMessageEvent = event;
        yield OpenNewMessageState();
        break;
    }
  }

  Stream<MessagesState> mapMessagesLoadingToState(String currentUserID) async* {
    yield MessagesLoading();
    try {
      final List<StudentWithDirectorAndTeachers> data =
          await _messagingRepository.getAllAboutAllStudents();
      final List<dynamic> conversations =
          await _messagingRepository.getAllConversation();
      final CEO ceo = await _messagingRepository.getCEO();

      yield MessagesLoaded(conversations: conversations, ceo: ceo, data: data);
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
    String contactID,
    int type,
  ) async* {
    WithMessagesMixin conversation;
    switch (type) {
      case 1:
        conversation = await _messagingRepository.getCEOWithMessages();
        break;
      case 2:
        conversation =
            await _messagingRepository.getDirectorWithMessages(contactID);
        break;
      case 3:
        conversation =
            await _messagingRepository.getTeacherWithMessages(contactID);
        break;
    }

    yield OpenConversationState(conversation: conversation);
  }
}
