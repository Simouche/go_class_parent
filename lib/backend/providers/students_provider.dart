import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/models/student.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';

class StudentProvider extends BaseStudentProvider with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  @override
  Future<List<Student>> getStudents(String parentID) async {
    final response =
        await client.get("getChildren", queries: {"userID": parentID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final List<Student> students = List();
        json['data']['children']
            .forEach((student) => students.add(Student.fromJson(student)));
        return students;
      }
    }
    return null;
  }

  @override
  Future<bool> requestStudentsPermission(
      String parent, List<String> students) async {
    // TODO: implement requestStudentsPermission
    throw UnimplementedError();
  }
}
