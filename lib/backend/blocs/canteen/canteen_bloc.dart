import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

part 'canteen_event.dart';
part 'canteen_state.dart';

class CanteenBloc extends Bloc<CanteenEvent, CanteenState> {
  CanteenBloc() : super(CanteenLoadingState());

  final CanteenRepository _canteenRepository = CanteenRepository();

  @override
  Stream<CanteenState> mapEventToState(
    CanteenEvent event,
  ) async* {
    yield* mapLoadCanteenEventToState(
        (event as LoadCanteenEvent).currentUserID);
  }

  Stream<CanteenState> mapLoadCanteenEventToState(String currentUserID) async* {
    yield CanteenLoadingState();
    try {
      final List<Canteen> canteens =
          await _canteenRepository.loadCanteen(currentUserID);
      yield CanteenLoadedState(canteens: canteens);
    } on Exception catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield CanteenLoadingFailedState();
    }
  }
}
