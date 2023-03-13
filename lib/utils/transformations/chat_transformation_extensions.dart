import 'package:linx/features/app/chat/data/model/message_dto.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

extension MessageTransformations on MessageDTO {
  Message toDomain() {
    return Message(
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      content: content,
      chatId: chatId,
      messageId: messageId,
      sentByUserType: UserType.values
          .firstWhere((element) => element.name == sentByUserType),
    );
  }
}
