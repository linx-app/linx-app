import 'package:linx/firebase/firestore_paths.dart';

class MessageDTO {
  final String messageId;
  final String chatId;
  final String content;
  final String sentByUserType;
  final int createdAt;

  MessageDTO({
    required this.messageId,
    required this.chatId,
    required this.content,
    required this.sentByUserType,
    required this.createdAt,
  });

  static MessageDTO fromNetwork(String id, Map<String, dynamic> map) {
    return MessageDTO(
      messageId: id,
      chatId: map[FirestorePaths.CHAT_ID] ?? "",
      content: map[FirestorePaths.CONTENT] ?? "",
      sentByUserType: map[FirestorePaths.SENT_BY_USER_TYPE] ?? "",
      createdAt: map[FirestorePaths.CREATED_AT] ?? 0
    );
  }
}
