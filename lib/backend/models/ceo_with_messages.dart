import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/db/local_db.dart';

import 'ceo.dart';
import 'message.dart';

class CeoWithMessages extends Equatable {
  final CEO ceo;
  final List<Message> messages;

  CeoWithMessages({this.ceo, this.messages});

  static CeoWithMessages filterCeoWithMessages(
      {CEO ceo, List<Message> messages}) {
    final CeoWithMessages ceoWithMessage = CeoWithMessages(
        ceo: ceo,
        messages: messages
            .where((message) =>
                message.senderId == ceo.serverID ||
                message.receiverId == ceo.serverID)
            .toList());
    return ceoWithMessage;
  }

  static Future<CeoWithMessages> getCEOWithMessages(LocalDB database) async {
    final CEO ceo = await CEO.getCEOFromDB(database);
    final List<Message> messages =
        await Message.getConversation(database, ceo.serverID);
    return CeoWithMessages(ceo: ceo, messages: messages);
  }

  @override
  List<Object> get props => [this.ceo, this.messages];

  @override
  String toString() => "$ceo";
}
