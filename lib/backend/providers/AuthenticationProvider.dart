import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_class_parent/backend/db/local_db.dart';
import 'package:go_class_parent/backend/http/client.dart';
import 'package:go_class_parent/backend/http/http_handler.dart';
import 'package:go_class_parent/backend/models/models.dart';

import 'base_providers.dart';
import 'settings_provider.dart';

class AuthenticationProvider extends BaseAuthenticationProvider
    with HttpHandlerMixin {
  final LocalDB database = LocalDB();
  final HttpClient client = HttpClient();

  String _username, _password, _registrationCode;
  String resetPasswordUser;

  AuthenticationProvider();

  @override
  Future<User> getCurrentUser() async {
    final User user = await User.getCurrentUser(database);
    return user;
  }

  @override
  Future<bool> isLoggedIn() async {
    List<Map<String, dynamic>> result = await database.query(
        tableName: "users",
        columns: ["*"],
        where: null,
        whereArgs: null,
        distinct: false,
        groupBy: null,
        having: null,
        limit: 1,
        offset: null);
    return result.isNotEmpty;
  }

  @override
  Future<User> signIn() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    final String token = await _firebaseMessaging.getToken();
    final response = await client.post("login",
        {'username': _username, 'password': _password, 'token': token});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final int rows = await User.insert(database, json);
        final User user = User.fromJson(json);
        final bool setUp = SettingsProvider.checkAndSetUpCustomDomain(json);
        if (setUp) {
          final response2 = await client
              .get('get-parent', queries: {"userID": user.serverId});
          final status2 = handleHttpCode(response2.statusCode);
          if (status2) {
            final json2 = jsonDecode(response2.body);
            final int rows2 =
                await Parent.insertParentFromJson(database, json2);
          }
        } else {
          final int rows2 = await Parent.insertParentFromJson(database, json);
        }
        return user;
      }
    }
    return null;
  }

  @override
  Future<Void> signOut() async {
    print('Signed Out!');
    return null;
  }

  Future<String> getDomain(String suffix) async {
    final response =
        await client.get('get-domain', queries: {'suffix': suffix});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      return json['data']['domain'];
    }
    return null;
  }

  @override
  Future<bool> checkCode() async {
    final response = await client
        .post('check-code', {'registration_code': _registrationCode});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error'] &&
          json['data']['domain'] != null &&
          json['data']['domain'].isNotEmpty) {
        client.urls(json['domain']);
        final response2 = await client
            .post('check-code', {'registration_code': _registrationCode});
        final status2 = handleHttpCode(response2.statusCode);
        if (status2) {
          final json2 = jsonDecode(response.body);
          return !json2['error'];
        }
      }
      return !json['error'];
    }
    return false;
  }

  @override
  Future<bool> checkResetCode() async {
    final response = await client
        .post('check-reset-code', {'registration_code': _registrationCode});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error'] &&
          json['data']['domain'] != null &&
          json['data']['domain'].isNotEmpty) {
        client.urls(json['domain']);
        final response2 = await client
            .post('check-reset-code', {'registration_code': _registrationCode});
        final status2 = handleHttpCode(response2.statusCode);
        if (status2) {
          final json2 = jsonDecode(response.body);
          resetPasswordUser = json2["data"]["userID"];
          return !json2['error'];
        }
      }
      resetPasswordUser = json["data"]["userID"];
      return !json['error'];
    }
    return false;
  }

  @override
  Future<bool> register() async {
    client.urls("https://lakkini.com");
    final response = await client.post('register-parent-user', {
      'username': _username,
      'password': _password,
      'registration_code': _registrationCode
    });
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      if (!json['error']) {
        final int rows = await User.insert(database, json);
        if (rows > 0) {
          final User user = User.fromJson(json);
          int rows = await Parent.insertParentFromJson(database, json);
          if (rows == 0) {
            SettingsProvider.checkAndSetUpCustomDomain(json);
            final response = await client.post('register-parent-user', {
              'registration_code': _registrationCode,
              'userID': user.serverId,
            });
            final status = handleHttpCode(response.statusCode);
            if (status) {
              final json = jsonDecode(response.body);
              if (!json['error']) {
                int rows = await Parent.insertParentFromJson(database, json);
                return true;
              }
            }
          }
          return true;
        }
      }
    }
    return false;
  }

  set username(String username) => _username = username;

  set password(String password) => _password = password;

  set registrationCode(String registrationCode) =>
      _registrationCode = registrationCode;

  @override
  Future<Parent> getCurrentParent() async {
    final Parent parent = await Parent.getCurrentParent(database);
    return parent;
  }

  void logout() {
    database.delete(tableName: "users");
    database.delete(tableName: "parents");
  }

  @override
  Future<String> resetPassword(String code) async {
    _registrationCode = code;
    final result = await checkResetCode();
    if (result) {
      return resetPasswordUser;
    } else {
      return null;
    }
  }

  @override
  Future<bool> changePassword(String password, String userID) async {
    final response = await client.get("setNewPassword",
        queries: {"password": password, "userID": userID});
    final status = handleHttpCode(response.statusCode);
    if (status) {
      final json = jsonDecode(response.body);
      return !json['error'];
    }
    return false;
  }
}
