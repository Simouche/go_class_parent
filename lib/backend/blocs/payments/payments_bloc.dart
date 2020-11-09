import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/repositories/payments_repository.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(PaymentsLoading());

  final PaymentsRepository _paymentsRepository = PaymentsRepository();

  @override
  Stream<PaymentsState> mapEventToState(
    PaymentsEvent event,
  ) async* {
    yield* mapLoadPaymentsEventToState(
        (event as LoadPaymentsEvent).currentUserID);
  }

  Stream<PaymentsState> mapLoadPaymentsEventToState(
      String currentUserID) async* {
    yield PaymentsLoading();
    try {
      final Map<String, List<Payment>> payments =
          await _paymentsRepository.loadPayments(currentUserID);
      yield PaymentsLoaded(payments: payments);
    } on Exception catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      yield PaymentsLoadingFailed();
    }
  }
}
