import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/utils/transformations/chat_transformation_extensions.dart';

class SubscribeToChatService {
  static final provider = Provider(
      (ref) => SubscribeToChatService(ref.read(MessageRepository.provider)));

  final MessageRepository _messageRepository;

  SubscribeToChatService(this._messageRepository);

  Stream<List<Message>> execute(String chatId) {
    return _messageRepository
        .subscribeToNewMessages(chatId)
        .map((event) => event.map((e) => e.toDomain()).toList());
  }
}
