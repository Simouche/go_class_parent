import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/canteen.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';

class CanteenProvider extends BaseCanteenProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<List<Canteen>> loadCanteen(String currentUserID) async {
    final response =
        await client.get('get-all-canteen', queries: {'userID': currentUserID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final List<Canteen> canteens = List();
        json['data']['canteen'].forEach(
          (canteen) => canteens.add(
            Canteen.fromJson(canteen),
          ),
        );
        return canteens;
      }
      return null;
    }
    return null;
  }
}
