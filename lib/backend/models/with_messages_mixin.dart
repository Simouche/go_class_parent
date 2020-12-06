import 'package:go_class_parent/backend/models/message.dart';

abstract class WithMessagesMixin {
  String getName();

  int getType();

  int length();

  List<Message> getMessages();
}