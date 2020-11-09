import 'package:go_class_parent/backend/models/canteen.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class CanteenRepository {
  CanteenProvider _canteenProvider = CanteenProvider();

  Future<List<Canteen>> loadCanteen(String currentUserID) async =>
      await _canteenProvider.loadCanteen(currentUserID);
}
