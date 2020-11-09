import 'package:go_class_parent/backend/providers/providers.dart';

class ScheduleRepository {
  final ScheduleProvider _scheduleProvider = ScheduleProvider();

  Future<Map<String, dynamic>> loadSchedules(String currentUserID) async =>
      _scheduleProvider.loadSchedules(currentUserID);
}
