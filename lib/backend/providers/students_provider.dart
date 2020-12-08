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
        json['data']['children'].forEach((student) {
          student["student"]["state"] = student["state"];
          student = student["student"];
          students.add(Student.fromJson(student));
        });
        return students;
      }
    }
    return null;
  }

  @override
  Future<bool> requestStudentsPermission(
      String parent, List<String> students) async {
    final response = await client.post("requestChildren",
        {"userID": parent, "children": json.encode(students)});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      print(json);
      if (!json['error']) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<List<Student>> getStudentsLocal(String parentID) async {
    return await Student.getAllFromDB(database);
  }
}
