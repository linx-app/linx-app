import 'package:linx/features/app/pitch/data/model/pitch_dto.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

extension PitchTransformationExtensions on PitchDTO {
  Request toDomain(LinxUser sender, LinxUser receiver) {
    return Request(
      id: id,
      sender: sender,
      receiver: receiver,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdDate),
      message: message,
      hasBeenViewed: viewed,
    );
  }
}
