import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/payment.dart';

import 'base_providers.dart';

class PaymentsProvider extends BasePaymentProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<Map<String, List<Payment>>> loadPayments(String currentUserID) async {
    final response = await client
        .get('get-all-payments', queries: {'userID': currentUserID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final Map<String, List<Payment>> payments = Map();
        int s = 1;
        json['data']['payments'].forEach((e) {
          payments[e['name']] =
              e['payments'].map<Payment>((e) => Payment.fromJson(e)).toList();
          s++;
        });
        return payments;
      }
      return null;
    }
    return null;
  }
}
