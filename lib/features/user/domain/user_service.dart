import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/user/data/model/firestore_user.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class UserService {
  static final provider = Provider((ref) {
    return UserService(
      ref.read(UserRepository.provider),
      ref.read(SessionRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    );
  });

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  UserService(this._userRepository, this._sessionRepository, this._sponsorshipPackageRepository);

  Future<LinxUser> fetchUserProfile() async {
    var uid = await _sessionRepository.getUserId();
    FirestoreUser networkUser = await _userRepository.fetchUserProfile(uid);
    LinxUser domainUser = LinxUser(
      uid: networkUser.uid,
      displayName: networkUser.displayName,
      email: networkUser.email,
      phoneNumber: networkUser.phoneNumber,
      type: UserType.values.firstWhere((e) => e.name == networkUser.type),
      biography: networkUser.biography,
      location: networkUser.location,
      interests: networkUser.interests.toSet(),
      descriptors: networkUser.descriptors.toSet(),
      packages: await _sponsorshipPackageRepository.fetchSponsorshipPackages(networkUser.packages),
    );
    return domainUser;
  }
}
