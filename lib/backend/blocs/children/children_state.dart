part of 'children_bloc.dart';

abstract class ChildrenState extends Equatable {
  const ChildrenState();
}

class ChildrenInitial extends ChildrenState {
  @override
  List<Object> get props => [];
}

class StudentLoadingState extends ChildrenState {
  @override
  List<Object> get props => [];
}

class StudentLoadingSuccessState extends ChildrenState {
  final List<Student> students;

  StudentLoadingSuccessState({this.students});

  @override
  List<Object> get props => [students];
}

class StudentLoadingFailedState extends ChildrenState {
  @override
  List<Object> get props => [];
}

class RequestStudentPermissionLoadingState extends ChildrenState {
  @override
  List<Object> get props => [];
}

class RequestStudentPermissionFailedState extends ChildrenState {
  @override
  List<Object> get props => [];
}

class RequestStudentPermissionSuccessState extends ChildrenState {
  @override
  List<Object> get props => [];
}

class CheckQrCodeSuccessState extends ChildrenState {
  final List<String> selectedStudents;

  CheckQrCodeSuccessState({this.selectedStudents});

  @override
  List<Object> get props => [];
}

class CheckQrCodeFailedState extends ChildrenState {
  @override
  List<Object> get props => [];
}
