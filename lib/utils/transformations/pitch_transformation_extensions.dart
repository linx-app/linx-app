import 'package:linx/features/app/home/data/model/pitch_dto.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
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
