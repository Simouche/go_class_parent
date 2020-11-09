import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/schedule.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';

class ScheduleProvider extends BaseSchedulesProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<Map<String, dynamic>> loadSchedules(String userID) async {
    final response =
        await client.get('get-all-schedules', queries: {'userID': userID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final List<Schedule> schedules = List();
        json['data']['classes']
            .forEach((schedule) => schedules.add(Schedule.fromJson(schedule)));
        final List<String> classes =
            schedules.map((e) => e.toString()).toList();
        return {'schedules': schedules, 'classes': classes};
      }
      return null;
    }
    return null;
  }
}
