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
  final List<dynamic> fileUrl;

  static const String TABLE_NAME = "messages";

  Message(
      {this.serverId,
      this.id,
      this.message,
      this.date,
      this.seen,
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
      fileUrl: json['fileUrl']?.map((e) {
        if (e is String)
          return AttachmentFile(
              url: extractUrl(e), name: e.substring(e.lastIndexOf("/")));
        else
          return AttachmentFile(
              type: "M",
              url: extractUrl(e['path'] as String),
              name: e['originalname']);
      })?.toList(),
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "SUBJECT": subject,
      "MESSAGE": message,
      "DATE": date,
      "TIME": time,
      "APPROVED": approved,
      "SEEN": seen,
      "SENDER_ID": senderId,
      "RECEIVER_ID": receiverId,
      "SERVER_ID": serverId,
    };
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

  Future<bool> saveToDB(LocalDB db) async {
    final int result = await db.insert(tableName: TABLE_NAME, values: toMap());
    return result > 0;
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
