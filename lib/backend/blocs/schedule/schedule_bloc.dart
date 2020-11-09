import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(SchedulesLoading());

  final ScheduleRepository _scheduleRepository = ScheduleRepository();

  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    yield* mapLoadSchedulesEventToState(
        (event as LoadScheduleEvent).currentUserID);
  }

  Stream<ScheduleState> mapLoadSchedulesEventToState(
      String currentUserID) async* {
    yield SchedulesLoading();
    try {
      final Map<String, dynamic> schedules =
          await _scheduleRepository.loadSchedules(currentUserID);
      yield SchedulesLoaded(schedules: schedules);
    } on Exception catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield SchedulesLoadingFailed();
    }
  }
}
