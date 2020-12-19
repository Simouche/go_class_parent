import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/home_work_provider.dart';

class HomeWorkRepository {
  final HomeWorkProvider _provider = HomeWorkProvider();

  Future<List<ClassWithHomeWorks>> getHomeWorks(String userID) async =>
      await _provider.getHomeWorks(userID);
}
