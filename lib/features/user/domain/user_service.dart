import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

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

  UserService(this._userRepository, this._sessionRepository,
      this._sponsorshipPackageRepository);

  Future<UserInfo> fetchUserInfo() async {
    var uid = _sessionRepository.userId;
    UserDTO networkUser = await _userRepository.fetchUserProfile(uid);
    return networkUser.toDomain();
  }

  Future<LinxUser> fetchUser() async {
    final uid = _sessionRepository.userId;
    final networkUserInfo = await _userRepository.fetchUserProfile(uid);
    final domainUserInfo = networkUserInfo.toDomain();
    final networkPackages =
        await _sponsorshipPackageRepository.fetchSponsorshipPackagesByUser(uid);
    final domainPackages =
        networkPackages.map((e) => e.toDomain(domainUserInfo));
    return LinxUser(
      info: domainUserInfo,
      packages: domainPackages.toList(),
      matchPercentage: 0,
    );
  }
}
