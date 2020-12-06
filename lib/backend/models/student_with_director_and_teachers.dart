import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/models/director.dart';
import 'package:go_class_parent/backend/models/student.dart';
import 'package:go_class_parent/backend/models/student_with_teachers.dart';
import 'package:go_class_parent/backend/models/teacher.dart';

class StudentWithDirectorAndTeachers extends Equatable {
  final Student student;
  final Director director;
  final List<Teacher> teachers;

  StudentWithDirectorAndTeachers({this.student, this.director, this.teachers});

  @override
  List<Object> get props => [this.student, this.director, this.teachers];

  static Future<List<StudentWithDirectorAndTeachers>> getAllFromDB(
      LocalDB database) async {
    final List<StudentWithTeachers> studentWithTeachers =
        await StudentWithTeachers.getAllFromDB(database);
    final List<StudentWithDirectorAndTeachers> studentWithDirectorAndTeachers =
        List();
    studentWithTeachers.forEach((StudentWithTeachers element) async {
      final Director director =
          await Director.getDirector(database, element.student.director);
      studentWithDirectorAndTeachers.add(StudentWithDirectorAndTeachers(
          student: element.student,
          director: director,
          teachers: element.teachers));
    });
    return studentWithDirectorAndTeachers;
  }

  static Future<StudentWithDirectorAndTeachers> getByStudent(
      LocalDB database, String student) async {
    final StudentWithTeachers studentWithTeachers =
        await StudentWithTeachers.getStudentWithTeachers(database, student);
    return StudentWithDirectorAndTeachers(
        student: studentWithTeachers.student,
        teachers: studentWithTeachers.teachers,
        director: (await Director.getDirector(
            database, studentWithTeachers.student.director)));
  }
}
