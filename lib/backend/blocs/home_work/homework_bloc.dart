import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/home_work.dart';
import 'package:go_class_parent/backend/repositories/home_work_repository.dart';

part 'homework_event.dart';

part 'homework_state.dart';

class HomeWorkBloc extends Bloc<HomeWorkEvent, HomeWorkState> {
  HomeWorkBloc() : super(HomeworkInitial());

  HomeWorkRepository _repository = HomeWorkRepository();

  @override
  Stream<HomeWorkState> mapEventToState(
    HomeWorkEvent event,
  ) async* {
    yield* mapLoadHomeWorkEventToState((event as OpenHomeWorkPageEvent).userID);
  }

  Stream<HomeWorkState> mapLoadHomeWorkEventToState(String userID) async* {
    yield HomeWorkLoadingState();
    try {
      final List<ClassWithHomeWorks> homeWorks =
          await _repository.getHomeWorks(userID);
      yield HomeWorkLoadedSuccessState(homeWorks: homeWorks);
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      yield HomeWorkLoadedFailedState();
    }
  }
}
