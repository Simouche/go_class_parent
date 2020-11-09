part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();
}

class LoadPaymentsEvent extends PaymentsEvent {
  final String currentUserID;

  const LoadPaymentsEvent({this.currentUserID});

  @override
  List<Object> get props => throw UnimplementedError();
}
