import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/attendance.dart';

import 'base_providers.dart';

class AttendanceProvider extends BaseAttendanceProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<List<Attendance>> loadAttendance(String childID) async {
    final response =
        await client.get('get-attendance', queries: {'childID': childID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final List<Attendance> attendances = List();
        json['data']['attendance'].forEach(
          (attendance) => attendances.add(
            Attendance.fromJson(attendance),
          ),
        );
        return attendances;
      }
    }
    return null;
  }
}
