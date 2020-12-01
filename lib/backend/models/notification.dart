import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'attachement_file.dart';
import 'utils.dart';

class Notification extends Equatable {
  final int id;
  final String classId;
  final String receiver;
  final bool approved;
  final String date;
  final bool isNew;
  final bool seen;
  final String message;
  final String title;
  final String from;
  final String serverId;
  final String userId;
  final List<dynamic> fileUrl;

  static const String TABLE_NAME = "notifications";

  Notification({
    this.serverId,
    this.id,
    this.date,
    this.isNew,
    this.message,
    this.title,
    this.from,
    this.classId,
    this.receiver,
    this.approved,
    this.seen,
    this.userId,
    this.fileUrl,
  });

  static Notification fromJson(Map json) {
    return Notification(
      serverId: json['_id'],
      receiver: json['receiver'],
      classId: json['classId'],
      userId: json['UserId'],
      message: json['Description'],
      title: json['subject'],
      date: json['date'],
      approved: json['Prooved']['Prooved'],
      fileUrl: json['file']
          .map((e) => AttachmentFile(
              type: "N",
              url: extractUrl(e['path'] as String),
              name: e['originalname']))
          .toList(),
    );
  }

  static Notification fromDB(Map<String, dynamic> row) {
    return Notification(
      id: row["ID"],
      serverId: row["SERVER_ID"],
      classId: row["CLASS_ID"],
      receiver: row["RECEIVER"],
      approved: row["APPROVED"],
      date: row["DATE"],
      seen: row["SEEN"],
      userId: row["USER_ID"],
      isNew: row["NEW"],
      message: row["MESSAGE"],
      title: row["TITLE"],
      from: row["FROM_"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "SERVER_ID": serverId,
      "CLASS_ID": classId,
      "RECEIVER": receiver,
      "APPROVED": approved,
      "DATE": date,
      "SEEN": seen,
      "USER_ID": userId,
      "NEW": isNew,
      "MESSAGE": message,
      "TITLE": title,
      "FROM_": from,
    };
  }

  static Future<List<Notification>> getAllFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
        tableName: TABLE_NAME, columns: ["*"], orderBy: "id");
    final List<Notification> notifications = List();
    results.forEach((element) {
      notifications.add(Notification.fromDB(element));
    });
    return notifications;
  }

  Future<bool> saveToDB(LocalDB db) async {
    final int result = await db.insert(tableName: TABLE_NAME, values: toMap());
    return result > 0;
  }

  @override
  List<Object> get props => [
        id,
        classId,
        receiver,
        approved,
        date,
        isNew,
        seen,
        message,
        title,
        from,
        serverId,
        userId,
        fileUrl
      ];
}
