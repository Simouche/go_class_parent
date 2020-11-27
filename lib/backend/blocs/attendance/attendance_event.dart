part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
}

class OpenAttendanceChildrenPage extends AttendanceEvent {
  final String parentID;

  OpenAttendanceChildrenPage({this.parentID});

  @override
  List<Object> get props => [this.parentID];
}

class LoadAttendanceEvent extends AttendanceEvent {
  final String id;

  LoadAttendanceEvent({this.id});

  @override
  List<Object> get props => [id];
}
