import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/utils/transformations/chat_transformation_extensions.dart';

class FetchMessagesService {
  static final provider = Provider((ref) => FetchMessagesService(
    ref.read(MessageRepository.provider),
  ));

  final MessageRepository _messageRepository;

  FetchMessagesService(this._messageRepository);

  Future<List<Message>> execute(String chatId) async {
    final messages = await _messageRepository.fetchMessagesFromChat(chatId);
    return messages.map((e) => e.toDomain()).toList();
  }
}