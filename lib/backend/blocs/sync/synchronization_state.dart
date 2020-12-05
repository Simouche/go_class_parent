part of 'synchronization_bloc.dart';

abstract class SynchronizationState extends Equatable {
  const SynchronizationState();
}

class SynchronizationInitial extends SynchronizationState {
  @override
  List<Object> get props => [];
}

class SynchronizationLoadingState extends SynchronizationState {
  @override
  List<Object> get props => [];
}

class SynchronizationFailedState extends SynchronizationState {
  @override
  List<Object> get props => [];
}

class SynchronizationSuccessState extends SynchronizationState {
  @override
  List<Object> get props => [];
}
