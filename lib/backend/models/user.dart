import 'package:go_class_parent/backend/db/local_db.dart';

class User {
  final int id;
  final String username;
  final String authToken;
  final String serverId;

  User({this.id, this.serverId, this.username, this.authToken});

  static User fromJson(json) {
    return User(
        id: 0,
        username: json['data']['user']['username'],
        serverId: json['data']['user']['_id'],
        authToken: "test");
  }

  static Future<int> insert(LocalDB database, Map json) async {
    final int rows = await database.insert(tableName: "users", values: {
      "USERNAME": json['data']['user']['username'],
      "SERVER_ID": json['data']['user']['_id'],
      "AUTH_TOKEN": "test"
    });
    return rows;
  }

  static Future<User> getCurrentUser(LocalDB database) async {
    List<Map<String, dynamic>> result =
        await database.query(tableName: "parents", columns: ["*"]);
    return result.isNotEmpty
        ? User(
            id: result[0]['ID'],
            username: result[0]['USERNAME'],
            serverId: result[0]['SERVER_ID'],
            authToken: result[0]['AUTH_TOKEN'],
          )
        : null;
  }
}
