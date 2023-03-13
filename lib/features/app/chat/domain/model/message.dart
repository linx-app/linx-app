import 'package:linx/features/user/domain/model/user_type.dart';

class Message {
  final String content;
  final String messageId;
  final String chatId;
  final UserType sentByUserType;
  final DateTime createdAt;

  Message({
    required this.createdAt,
    required this.content,
    required this.messageId,
    required this.chatId,
    required this.sentByUserType,
  });
}
