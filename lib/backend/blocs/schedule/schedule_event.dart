part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleEvent extends Equatable {}

class LoadScheduleEvent extends ScheduleEvent{
  final String currentUserID;

  LoadScheduleEvent({this.currentUserID});

  @override
  List<Object> get props => [];
}
