part of 'children_bloc.dart';

abstract class ChildrenEvent extends Equatable {
  const ChildrenEvent();
}

class GetStudentsEventEvent extends ChildrenEvent {
  final String userID;

  GetStudentsEventEvent({this.userID});

  @override
  List<Object> get props => [userID];
}

class RequestStudentPermissionEvent extends ChildrenEvent {
  final List<String> students;
  final String parent;

  RequestStudentPermissionEvent({this.parent, this.students});

  @override
  List<Object> get props => [students];
}

class CheckQrCodeEvent extends ChildrenEvent {
  final String qrCode, parentCode;

  CheckQrCodeEvent({this.qrCode, this.parentCode});

  @override
  List<Object> get props => [qrCode];
}
