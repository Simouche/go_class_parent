part of 'synchronization_bloc.dart';

abstract class SynchronizationEvent extends Equatable {
  const SynchronizationEvent();
}

class TriggerSynchronizationEvent extends SynchronizationEvent {
  final String userID;

  TriggerSynchronizationEvent({this.userID});

  @override
  List<Object> get props => [this.userID];
}
