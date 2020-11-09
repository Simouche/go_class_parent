import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/payments_provider.dart';

class PaymentsRepository {
  final PaymentsProvider _paymentsProvider = PaymentsProvider();

  Future<Map<String, List<Payment>>> loadPayments(String currentUserID) async =>
      _paymentsProvider.loadPayments(currentUserID);
}
