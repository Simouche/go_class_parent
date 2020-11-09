part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleState extends Equatable {}

class SchedulesLoading extends ScheduleState {
  @override
  List<Object> get props => [];
}

class SchedulesLoaded extends ScheduleState {
  final Map<String, dynamic> schedules;

  SchedulesLoaded({this.schedules});
  @override
  List<Object> get props => [];
}

class SchedulesLoadingFailed extends ScheduleState {
  @override
  List<Object> get props => [];
}
