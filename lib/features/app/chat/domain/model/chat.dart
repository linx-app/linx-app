import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class Chat {
  final String chatId;
  final UserInfo club;
  final UserInfo business;
  final Message lastMessage;

  Chat({
    required this.chatId,
    required this.club,
    required this.business,
    required this.lastMessage,
  });
}
