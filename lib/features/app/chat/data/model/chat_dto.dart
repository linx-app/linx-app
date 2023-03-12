import 'package:linx/firebase/firestore_paths.dart';

class ChatDTO {
  final String clubId;
  final String businessId;
  final String lastMessageId;
  final String chatId;
  final bool hasNew;

  ChatDTO({
    required this.clubId,
    required this.businessId,
    required this.lastMessageId,
    required this.chatId,
    required this.hasNew,
  });

  static ChatDTO fromNetwork(String id, Map<String, dynamic> map) {
    return ChatDTO(
      clubId: map[FirestorePaths.CLUB] ?? "",
      businessId: map[FirestorePaths.BUSINESS] ?? "",
      lastMessageId: map[FirestorePaths.LAST_MESSAGE_ID] ?? "",
      chatId: id,
      hasNew: map[FirestorePaths.LAST_MESSAGE_NEW] ?? false,
    );
  }
}
