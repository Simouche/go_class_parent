part of 'homework_bloc.dart';

abstract class HomeWorkEvent extends Equatable {
  const HomeWorkEvent();
}

class OpenHomeWorkPageEvent extends HomeWorkEvent {
  final String userID;

  const OpenHomeWorkPageEvent({this.userID});

  @override
  List<Object> get props => [userID];
}
