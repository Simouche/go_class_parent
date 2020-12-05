import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/student.dart';
import 'package:go_class_parent/backend/models/teacher.dart';

class StudentWithTeachers extends Equatable {
  final Student student;
  final List<Teacher> teachers;

  static const String TABLE_NAME = "students_teachers";

  StudentWithTeachers({this.student, this.teachers});

  @override
  List<Object> get props => [this.student, this.teachers];

  static Future<List<StudentWithTeachers>> getAllFromDB(
      LocalDB database) async {
    final List<Student> students = await Student.getAllFromDB(database);
    final List<StudentWithTeachers> studentsWithTeachers = List();
    students.forEach((element) async {
      final List<Map<String, dynamic>> teachersOfStudent = await database.query(
          tableName: TABLE_NAME,
          columns: ["*"],
          where: "STUDENT_ID = ?",
          whereArgs: [element.serverID]);
      final List<String> teachersIDs = teachersOfStudent.map<String>(
          (Map<String, dynamic> element) => element["TEACHER_ID"] as String);
      final List<Teacher> teachers =
          await Teacher.getTeachersByIDs(database, teachersIDs);
      studentsWithTeachers
          .add(StudentWithTeachers(student: element, teachers: teachers));
    });
    return studentsWithTeachers;
  }

  static Future<StudentWithTeachers> getStudentWithTeachers(
      LocalDB database, String studentID) async {
    final Student student = await Student.getStudent(database, studentID);
    final List<Map<String, dynamic>> teachersOfStudent = await database.query(
        tableName: TABLE_NAME,
        columns: ["*"],
        where: "STUDENT_ID = ?",
        whereArgs: [student.serverID]);
    final List<String> teachersIDs = teachersOfStudent.map<String>(
        (Map<String, dynamic> element) => element["TEACHER_ID"] as String);
    final List<Teacher> teachers =
        await Teacher.getTeachersByIDs(database, teachersIDs);
    return StudentWithTeachers(student: student, teachers: teachers);
  }
}
