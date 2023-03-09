import 'package:linx/features/app/pitch/data/model/pitch_dto.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

extension PitchTransformationExtensions on PitchDTO {
  Request toDomain(DisplayUser sender, LinxUser receiver) {
    return Request(
      sender: sender,
      receiver: receiver,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdDate),
      message: message,
    );
  }
}

extension RequestTransformationExtensions on Request {
  PitchDTO toNetwork() {
    return PitchDTO(
        createdDate: createdAt.millisecondsSinceEpoch,
        message: message,
        receiverId: receiver.uid,
        senderId: sender.info.uid,
    );
  }
}
