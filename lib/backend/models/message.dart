import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'attachement_file.dart';
import 'utils.dart';

class Message extends Equatable {
  final int id;
  final String subject;
  final String message;
  final String date;
  final String time;
  final bool approved;
  final bool seen;
  final String senderId;
  final String receiverId;
  final String serverId;
  final List<AttachmentFile> fileUrl;
  final bool downloaded;

  static const String TABLE_NAME = "messages";

  Message(
      {this.downloaded,
      this.serverId,
      this.id,
      this.message,
      this.date,
      this.seen = false,
      this.senderId,
      this.subject,
      this.time,
      this.approved,
      this.receiverId,
      this.fileUrl});

  static Message fromJson(Map json) {
    return Message(
      serverId: json['_id'],
      subject: json['subject'],
      message: json['description'],
      date: json['date'],
      time: json['time'],
      approved: json['approved']['isApproved'],
      senderId: json['senderID'],
      receiverId: json['receiverID'],
      downloaded: false,
      fileUrl: (json['fileUrl'] as List).map<AttachmentFile>((e) {
        if (e is String)
          return AttachmentFile(
              url: extractUrl(e), name: e.substring(e.lastIndexOf("/")+1));
        else
          return AttachmentFile(
              type: "M",
              url: extractUrl(e['path'] as String),
              name: e['originalname']);
      }).toList(),
    );
  }

  static Message fromDB(Map<String, dynamic> row) {
    return Message(
      id: row["ID"],
      subject: row["SUBJECT"],
      message: row["MESSAGE"],
      date: row["DATE"],
      time: row["TIME"],
      approved: row["APPROVED"] == 1,
      seen: row["SEEN"] == 1,
      senderId: row["SENDER_ID"],
      receiverId: row["RECEIVER_ID"],
      serverId: row["SERVER_ID"],
      fileUrl: filesFromString(row["FILES"]),
      downloaded: row["DOWNLOADED"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "SUBJECT": subject,
      "MESSAGE": message,
      "DATE": date,
      "TIME": time,
      "APPROVED": approved ? 1 : 0,
      "SEEN": seen ? 1 : 0,
      "SENDER_ID": senderId,
      "RECEIVER_ID": receiverId,
      "SERVER_ID": serverId,
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

  static Future<List<Message>> getAllFromDB(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
        tableName: TABLE_NAME, columns: ["*"], orderBy: "ID");
    final List<Message> messages = List();
    results.forEach((element) => messages.add(Message.fromDB(element)));
    return messages;
  }

  static Future<List<Message>> getConversation(
      LocalDB database, String contactID) async {
    final List<Map<String, dynamic>> results = await database.query(
      tableName: TABLE_NAME,
      columns: ["*"],
      where: "SENDER_ID = ? OR RECEIVER_ID = ?",
      whereArgs: [contactID, contactID],
      orderBy: "ID",
    );
    final List<Message> messages = List();
    results.forEach((element) => messages.add(Message.fromDB(element)));
    return messages;
  }

  static Future<String> getLastMessageID(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
      tableName: TABLE_NAME,
      columns: ["*"],
      orderBy: "ID DESC",
      limit: 1,
    );
    return results.isNotEmpty ? fromDB(results.first).serverId : "none";
  }

  static Future<int> getNewMessagesCount(LocalDB database) async {
    final List<Map<String, dynamic>> results = await database.query(
      tableName: TABLE_NAME,
      columns: ["COUNT(*) as number"],
      where: "SEEN = ?",
      whereArgs: [0],
    );
    return results.isNotEmpty ? results.first["number"] : 0;
  }

  static Future<bool> markConversationAsRead(
      LocalDB database, String contactID) async {
    final int results = await database.update(
        tableName: TABLE_NAME,
        values: {"SEEN": 1},
        where: "SENDER_ID = ? OR RECEIVER_ID = ?",
        whereArgs: [contactID, contactID]);
    return results > 0;
  }

  Future<bool> saveToDB(LocalDB db) async {
    try {
      final int result =
          await db.insert(tableName: TABLE_NAME, values: toMap());
      return result > 0;
    } catch (e) {
      log("duplicate of $serverId");
      return false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': this.subject,
      'message': this.message,
      'date': this.date,
      'time': this.time,
      'sender_id': this.senderId,
      'receiver_id': this.receiverId,
    };
  }

  @override
  List<Object> get props => [
        id,
        subject,
        message,
        date,
        time,
        approved,
        seen,
        senderId,
        receiverId,
        fileUrl,
      ];

  @override
  String toString() => "$serverId";
}
