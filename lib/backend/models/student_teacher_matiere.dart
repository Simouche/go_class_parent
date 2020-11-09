import 'package:equatable/equatable.dart';

import 'director.dart';
import 'matiere.dart';
import 'student.dart';
import 'teacher.dart';

class TeacherAndMatiere extends Equatable {
  final Teacher teacher;
  final Matiere matiere;

  TeacherAndMatiere({this.teacher, this.matiere});

  @override
  // TODO: implement props
  List<Object> get props => [teacher, matiere];
}

class StudentWithTeachersAndMatieres extends Equatable {
  final Student student;
  final List<TeacherAndMatiere> teacherAndMatiere;
  final Director director;

  StudentWithTeachersAndMatieres(
      {this.student, this.teacherAndMatiere, this.director});

  @override
  List<Object> get props => [student, teacherAndMatiere];

  @override
  String toString() => "${student.firstName}}";
}
