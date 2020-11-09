import 'package:equatable/equatable.dart';

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
