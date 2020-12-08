import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class StudentRepository {
  StudentProvider _studentProvider = StudentProvider();

  Future<List<Student>> getStudents(String userID) async {
    // final List<Student> students = await _studentProvider.getStudentsLocal("");
    // if (students.isNotEmpty) return students;
    return await _studentProvider.getStudents(userID);
  }

  Future<bool> requestStudentsPermission(
          String parent, List<String> students) async =>
      _studentProvider.requestStudentsPermission(parent, students);
}
