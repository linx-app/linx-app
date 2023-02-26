import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

extension UserDTOExtension on UserDTO {
  LinxUser toDomain() {
    return LinxUser(
      uid: uid,
      displayName: displayName,
      email: email,
      phoneNumber: phoneNumber,
      type: UserType.values.firstWhere((e) => e.name == type),
      biography: biography,
      location: location,
      interests: interests.toSet(),
      descriptors: descriptors.toSet(),
      numberOfPackages: numberOfPackages,
      profileImageUrls: profileImageUrls,
    );
  }
}
