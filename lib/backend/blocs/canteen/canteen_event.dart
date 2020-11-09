part of 'canteen_bloc.dart';

abstract class CanteenEvent extends Equatable {
  const CanteenEvent();
}

class LoadCanteenEvent extends CanteenEvent {
  final String currentUserID;

  LoadCanteenEvent({this.currentUserID});

  @override
  List<Object> get props => [currentUserID];
}
