part of 'payments_bloc.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();
}

class PaymentsLoading extends PaymentsState {
  @override
  List<Object> get props => [];
}

class PaymentsLoaded extends PaymentsState {
  final Map<String, List<Payment>> payments;

  PaymentsLoaded({this.payments});

  @override
  List<Object> get props => [payments];
}

class PaymentsLoadingFailed extends PaymentsState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
