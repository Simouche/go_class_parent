import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/backend/providers/providers.dart';

class AuthenticationRepository {
  final AuthenticationProvider _authProvider = AuthenticationProvider();

  Future<User> getCurrentUser() async => _authProvider.getCurrentUser();

  Future<bool> isLoggedIn() async => _authProvider.isLoggedIn();

  Future<User> signIn(String username, String password) async {
    // ToDo validate username and password
    _authProvider.username = username;
    _authProvider.password = password;
    return await _authProvider.signIn();
  }

  Future<bool> checkCode(String code) async {
    _authProvider.registrationCode = code;
    return await _authProvider.checkCode();
  }

  Future<bool> register(String username, String password, String code) async {
    _authProvider.username = username;
    _authProvider.password = password;
    _authProvider.registrationCode = code;
    return await _authProvider.register();
  }

  Future<Parent> getCurrentParent() async {
    return await _authProvider.getCurrentParent();
  }

  void logout() {
    _authProvider.logout();
  }

  Future<String> resetPassword(String code) async =>
      _authProvider.resetPassword(code);

  Future<bool> changePassword(String password, String userID) async =>
      changePassword(password, userID);
}
