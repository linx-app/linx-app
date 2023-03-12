import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/chat_repository.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';

class SendMessageService {
  static final provider = Provider((ref) => SendMessageService(
        ref.read(MessageRepository.provider),
        ref.read(ChatRepository.provider),
      ));

  final MessageRepository _messageRepository;
  final ChatRepository _chatRepository;

  SendMessageService(this._messageRepository, this._chatRepository);

  Future<void> execute(
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

    _messageRepository.createNewMessage(chatId, message, isCurrentClub);
  }
}
