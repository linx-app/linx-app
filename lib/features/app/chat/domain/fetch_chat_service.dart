import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/chat_repository.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/chat_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchChatService {
  static final provider = Provider(
    (ref) => FetchChatService(
      ref.read(ChatRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(MessageRepository.provider),
    ),
  );

  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final MessageRepository _messageRepository;

  FetchChatService(
    this._chatRepository,
    this._userRepository,
    this._messageRepository,
  );

  Future<Chat> execute(String chatId, LinxUser currentUser) async {
    final networkChat = await _chatRepository.fetchChatById(chatId);
    final isClub = currentUser.info.isClub();
    final otherUid = isClub ? networkChat.businessId : networkChat.clubId;
    final otherNetworkUser = await _userRepository.fetchUserProfile(otherUid);
    final otherUser = otherNetworkUser.toDomain();
    final message =
        await _messageRepository.fetchMessage(networkChat.lastMessageId);

    return Chat(
      chatId: chatId,
      club: isClub ? currentUser.info : otherUser,
      business: isClub ? otherUser : currentUser.info,
      lastMessage: message.toDomain(),
    );
  }
}
