import 'package:linx/features/app/pitch/data/model/pitch_dto.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

extension PitchTransformationExtensions on PitchDTO {
  Request toDomain(LinxUser sender, LinxUser receiver) {
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
        receiverId: receiver.info.uid,
        senderId: sender.info.uid,
    );
  }
}
