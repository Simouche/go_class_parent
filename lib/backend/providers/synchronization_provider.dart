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

      for (var element in json["teachers"]) {
        await Teacher.fromJson(element).saveToDB(database);
      }

      final List directorStudent = json["directorStudent"];

      for (var element in json["children"]) {
        element["director"] = directorStudent
            .where((tuple) => tuple["studentID"] == element["_id"])
            .first["directorID"];
        final Student student = Student.fromJson(element);
        await student.saveToDB(database);
      }

      for (var element in json["directors"]) {
        await Director.fromJson(element).saveToDB(database);
      }

      await CEO.fromJson(json["ceo"]).saveToDB(database);

      for (var element in json["teacherStudent"]) {
        await StudentWithTeachers.saveToDB(database,
            studentID: element["studentID"], teacherID: element["teacherID"]);
      }

      _settingsProvider.setSynced();

      return true;
    }
    return false;
  }

  @override
  Future<CEO> getCEO() async {
    return await CEO.getCEOFromDB(database);
  }

  @override
  Future<Director> getDirector(String directorID) async {
    return await Director.getDirector(database, directorID);
  }

  @override
  Future<StudentWithDirectorAndTeachers> getAllAboutStudent(
      String studentID) async {
    return await StudentWithDirectorAndTeachers.getByStudent(
        database, studentID);
  }

  @override
  Future<List<StudentWithDirectorAndTeachers>> getAllAboutAllStudents() async {
    return await StudentWithDirectorAndTeachers.getAllFromDB(database);
  }
}
