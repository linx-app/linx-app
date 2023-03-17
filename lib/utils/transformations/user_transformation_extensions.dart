import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

extension UserDTOExtension on UserDTO {
  UserInfo toDomain() {
    return UserInfo(
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
      pitchesTo: pitchesTo,
      searches: searches,
      newMatches: newMatches,
      numberOfNewPitches: numberOfNewPitches,
      newChats: newChats,
    );
  }
}
