import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

part 'attendance_event.dart';

part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial());

  AttendanceRepository _repository = AttendanceRepository();

  @override
  Stream<AttendanceState> mapEventToState(
    AttendanceEvent event,
  ) async* {
    yield* mapLoadAttendanceEventToState((event as LoadAttendanceEvent).id);
  }

  Stream<AttendanceState> mapOpenAttendanceChildrenPage(
      String parentID) async* {
    yield OpenAttendanceChildrenPageLoading();
  }

  Stream<AttendanceState> mapLoadAttendanceEventToState(String childID) async* {
    yield AttendanceLoadingState();
    try {
      final List<Attendance> attendances =
          await _repository.getAttendances(childID);
      yield AttendanceLoadedState(attendances: attendances);
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      yield AttendanceLoadingFailedState();
    }
  }
}
