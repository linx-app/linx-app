import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/chat_repository.dart';
import 'package:linx/features/app/chat/data/message_repository.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/chat_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchAllChatsService {
  static final provider = Provider(
    (ref) => FetchAllChatsService(
      ref.read(ChatRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(MessageRepository.provider),
    ),
  );

  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  final MessageRepository _messageRepository;

  FetchAllChatsService(
    this._chatRepository,
    this._userRepository,
    this._messageRepository,
  );

  Future<List<Chat>> execute(LinxUser currentUser) async {
    final isClub = currentUser.info.isClub();
    final uid = currentUser.info.uid;
    final networkChats = await _chatRepository.fetchAllChats(isClub, uid);
    final domainChats = <Chat>[];

    for (final chat in networkChats) {
      final networkLastMessage =
          await _messageRepository.fetchMessage(chat.lastMessageId);
      final domainLastMessage = networkLastMessage.toDomain();

      final otherUserId = isClub ? chat.businessId : chat.clubId;
      final otherUserNetwork = await _userRepository.fetchUserProfile(otherUserId);
      final otherUserDomain = otherUserNetwork.toDomain();

      domainChats.add(
        Chat(
          chatId: chat.chatId,
          club: isClub ? currentUser.info : otherUserDomain,
          business: isClub ? otherUserDomain : currentUser.info,
          lastMessage: domainLastMessage
        )
      );
    }

    return domainChats;
  }
}
