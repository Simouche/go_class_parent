import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

part 'synchronization_event.dart';

part 'synchronization_state.dart';

class SynchronizationBloc
    extends Bloc<SynchronizationEvent, SynchronizationState> {
  SynchronizationBloc() : super(SynchronizationInitial());

  final SynchronizationRepository repository = SynchronizationRepository();

  @override
  Stream<SynchronizationState> mapEventToState(
    SynchronizationEvent event,
  ) async* {
    switch (event.runtimeType) {
      case TriggerSynchronizationEvent:
        yield* mapTriggerSynchronizationEventToState(
            (event as TriggerSynchronizationEvent).userID);
        break;
    }
  }

  Stream<SynchronizationState> mapTriggerSynchronizationEventToState(
      String userID) async* {
    yield SynchronizationLoadingState();
    try {
      bool result = await repository.loadInitialData(userID);
      yield result
          ? SynchronizationSuccessState()
          : SynchronizationFailedState();
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      yield SynchronizationFailedState();
    }
  }
}
