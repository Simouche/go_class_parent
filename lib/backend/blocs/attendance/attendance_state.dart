part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {
  @override
  List<Object> get props => [];
}

class AttendanceLoadingState extends AttendanceState {
  @override
  List<Object> get props => [];
}

class AttendanceLoadedState extends AttendanceState {
  final List<Attendance> attendances;

  AttendanceLoadedState({this.attendances});

  @override
  List<Object> get props => [];
}

class AttendanceLoadingFailedState extends AttendanceState {
  @override
  List<Object> get props => [];
}

class OpenAttendanceChildrenPageFailed extends AttendanceState {
  @override
  List<Object> get props => [];
}

class OpenAttendanceChildrenPageSuccess extends AttendanceState {
  final List<Student> students;

  OpenAttendanceChildrenPageSuccess({this.students});

  @override
  List<Object> get props => [students];
}

class OpenAttendanceChildrenPageLoading extends AttendanceState {
  @override
  List<Object> get props => [];
}
