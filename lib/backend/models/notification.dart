import 'dart:developer';

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
  final List<AttachmentFile> fileUrl;
  final bool downloaded;

  static const String TABLE_NAME = "notifications";

  Notification({
    this.downloaded,
    this.serverId,
    this.id,
    this.date,
    this.isNew,
    this.message,
    this.title,
    this.from,
    this.classId,
    this.receiver,
    this.approved = true,
    this.seen = false,
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
      fileUrl: (json['file'] as List)
          .map<AttachmentFile>((e) => AttachmentFile(
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
      approved: row["APPROVED"] == 1,
      date: row["DATE"],
      seen: row["SEEN"] == 1,
      userId: row["USER_ID"],
      isNew: row["NEW"],
      message: row["MESSAGE"],
      title: row["TITLE"],
      from: row["FROM_"],
      fileUrl: filesFromString(row["FILES"]),
      downloaded: row["DOWNLOADED"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "SERVER_ID": serverId,
      "CLASS_ID": classId,
      "RECEIVER": receiver,
      "APPROVED": approved ? 1 : 0,
      "DATE": date,
      "SEEN": seen ? 1 : 0,
      "USER_ID": userId,
      "NEW": isNew,
      "MESSAGE": message,
      "TITLE": title,
      "FROM_": from,
      "FILES": filesAsString(),
    };
  }

  String filesAsString() {
    final StringBuffer buffer = StringBuffer("");
    for (AttachmentFile file in fileUrl) buffer.write("${file.url};");
    return buffer.toString();
  }

  static List<AttachmentFile> filesFromString(String urlsAsString) {
    List<String> splitted = urlsAsString.split(";");
    splitted = splitted.sublist(0, splitted.length - 1);
    return splitted
        .map<AttachmentFile>((e) => AttachmentFile(
      url: e,
      name: e.substring(e.lastIndexOf("/")+1).replaceAll(":", "_"),
    ))
        .toList();
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
    try {
      final int result =
          await db.insert(tableName: TABLE_NAME, values: toMap());
      log("finished inserting into the DB");
      return result > 0;
    } catch (e) {
      log("duplicate of $serverId");
      return false;
    }
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
