import 'package:equatable/equatable.dart';

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
