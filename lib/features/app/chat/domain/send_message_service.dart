import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/chat_repository.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class SendMessageService {
  static final provider = Provider(
    (ref) => SendMessageService(
      ref.read(MessageRepository.provider),
      ref.read(ChatRepository.provider),
      ref.read(UserRepository.provider),
    ),
  );

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;

  SendMessageService(
    this._messageRepository,
    this._chatRepository,
    this._userRepository,
  );

  Future<String> execute(
    bool isCurrentClub,
    String senderId,
    String receiverId,
    String message,
  ) async {
    final clubId = isCurrentClub ? senderId : receiverId;
    final businessId = isCurrentClub ? receiverId : senderId;

    late String chatId;
    String? attempt = await _chatRepository.fetchChat(clubId, businessId);

    if (attempt == null) {
      chatId = await _chatRepository.createNewChat(clubId, businessId);
    } else {
      chatId = attempt;
    }

    final messageId = await _messageRepository.createNewMessage(
        chatId, message, isCurrentClub);
    await _chatRepository.updateLastMessageId(chatId, messageId);
    await _userRepository.addNewChatId(receiverId, chatId);
    return chatId;
  }
}
