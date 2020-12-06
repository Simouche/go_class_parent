import 'dart:convert';

import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/models/student_with_teachers.dart';
import 'package:go_class_parent/backend/providers/base_providers.dart';
import 'package:go_class_parent/backend/providers/providers.dart';
import 'package:http/http.dart';

class SynchronizationProvider extends BaseSynchronizationProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  final SettingsProvider _settingsProvider = SettingsProvider();

  @override
  Future<bool> loadInitialData(String userID) async {
    final Response response =
        await client.get("get-parent-data", queries: {"user_id": userID});
    final bool status = handleHttpCode(response.statusCode);
    if (status) {
      Map<String, dynamic> json = jsonDecode(response.body);
      json = json["data"];

      json["teachers"].map<Teacher>((element) {
        Teacher.fromJson(element).saveToDB(database);
      });

      final List directorStudent = json["directorStudent"];

      json["children"].map<Student>((element) {
        element["director"] = directorStudent
            .where((element) => element["studentID"] == element["_id"])
            .first["directorID"];
        final Student student = Student.fromJson(element);
        student.saveToDB(database);
        return student;
      });

      json["directors"].map<Director>((element) {
        final Director director = Director.fromJson(element);
        director.saveToDB(database);
        return director;
      });

      CEO.fromJson(json["ceo"]).saveToDB(database);

      json["teacherStudent"].map((element) => StudentWithTeachers.saveToDB(
          database,
          studentID: element["studentID"],
          teacherID: element["teacherID"]));

      _settingsProvider.setSynced();

      return true;
    }
    return false;
  }
}
