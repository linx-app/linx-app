import 'package:linx/features/app/chat/domain/message.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class Chat {
  final LinxUser club;
  final LinxUser business;
  final Message lastMessage;

  Chat(this.club, this.business, this.lastMessage);
}