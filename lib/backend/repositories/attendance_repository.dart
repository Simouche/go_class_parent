import 'package:go_class_parent/backend/providers/providers.dart';

class AttendanceRepository {
  AttendanceProvider _provider = AttendanceProvider();

  Future<List<Attendance>> getAttendances(String childID) async => await _provider.loadAttendance(childID);
}