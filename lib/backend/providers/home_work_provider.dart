import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/home_work.dart';

import 'base_providers.dart';

class HomeWorkProvider extends BaseHomeWorkProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<List<ClassWithHomeWorks>> getHomeWorks(String userID) async {
    final response =
        await client.get("get-all-homework", queries: {"userID": userID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json["error"]) {
        final List<ClassWithHomeWorks> classesWithHomeWorks = List();
        json["data"]["homeWork"]?.forEach((element) =>
            classesWithHomeWorks.add(ClassWithHomeWorks.fromJson(element)));
        return classesWithHomeWorks;
      }
    }
    return [];
  }
}
