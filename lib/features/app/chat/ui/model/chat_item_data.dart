import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class ChatItemData {
  final String chatId;
  final String? imageUrl;
  final String name;
  final String lastMessage;
  final bool isNew;

  ChatItemData({
    required this.chatId,
    this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.isNew,
  });

  static ChatItemData fromChat(UserType currentUserType, Chat chat) {
    final isClub = currentUserType == UserType.club;
    final user = isClub ? chat.business : chat.club;
    final currentUser = isClub ? chat.club : chat.business;

    return ChatItemData(
      chatId: chat.chatId,
      name: user.displayName,
      lastMessage: chat.lastMessage.content,
      imageUrl: user.profileImageUrls.first,
      isNew: currentUser.newChats.contains(chat.chatId),
    );
  }
}
