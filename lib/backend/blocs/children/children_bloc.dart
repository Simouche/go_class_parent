import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/repositories.dart';

part 'children_event.dart';

part 'children_state.dart';

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  ChildrenBloc() : super(StudentLoadingState());

  final StudentRepository _studentRepository = StudentRepository();

  @override
  Stream<ChildrenState> mapEventToState(
    ChildrenEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetStudentsEventEvent:
        yield* mapGetStudentEventToState(
            (event as GetStudentsEventEvent).userID);
        break;
      case CheckQrCodeEvent:
        final nEvent = event as CheckQrCodeEvent;
        yield* mapCheckQrCodeEventToState(
            nEvent.qrCode, nEvent.parentCode, nEvent.selectedStudents);
        break;
      case RequestStudentPermissionEvent:
        final nEvent = event as RequestStudentPermissionEvent;
        yield* mapRequestStudentPermissionEventToState(
            nEvent.parent, nEvent.students);
        break;
    }
  }

  Stream<ChildrenState> mapGetStudentEventToState(String userID) async* {
    yield StudentLoadingState();
    try {
      final List<Student> students =
          await _studentRepository.getStudents(userID);
      yield StudentLoadingSuccessState(students: students);
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      yield StudentLoadingFailedState();
    }
  }

  Stream<ChildrenState> mapCheckQrCodeEventToState(
      String code, String parentCode, List<String> selectedStudents) async* {
    yield code == parentCode
        ? CheckQrCodeSuccessState(selectedStudents: selectedStudents)
        : CheckQrCodeFailedState();
  }

  Stream<ChildrenState> mapRequestStudentPermissionEventToState(
      String parent, List<String> students) async* {
    yield RequestStudentPermissionLoadingState();
    try {
      final bool result =
          await _studentRepository.requestStudentsPermission(parent, students);
      yield result
          ? RequestStudentPermissionSuccessState()
          : RequestStudentPermissionFailedState();
    } on Exception catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      yield RequestStudentPermissionFailedState();
    }
  }
}
