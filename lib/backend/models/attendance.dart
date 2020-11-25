import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String state, description;
  final AttendanceDate attendanceDate;

  Attendance({this.state, this.description, this.attendanceDate});

  @override
  List<Object> get props => [this.state, this.description, this.attendanceDate];

  static Attendance fromJson(Map json) {
    return Attendance(
      state: json['state'],
      description: json["description"],
      attendanceDate: AttendanceDate.fromJson(json['date']),
    );
  }
}

class AttendanceDate extends Equatable {
  final String scanTime, day, startTime;

  AttendanceDate({this.scanTime, this.day, this.startTime});

  static AttendanceDate fromJson(Map json) {
    return AttendanceDate(
      scanTime: json["scaneTime"],
      day: json["day"],
      startTime: json["startTime"],
    );
  }

  @override
  List<Object> get props => [scanTime, day, startTime];
}
