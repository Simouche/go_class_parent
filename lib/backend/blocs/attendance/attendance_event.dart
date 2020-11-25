part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
}

class LoadAttendanceEvent extends AttendanceEvent {
  final String id;

  LoadAttendanceEvent({this.id});

  @override
  List<Object> get props => [id];

}
