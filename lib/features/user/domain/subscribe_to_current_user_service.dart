import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class SubscribeToCurrentUserService {
  static final provider = Provider((ref) => SubscribeToCurrentUserService(
        ref.read(SessionRepository.provider),
        ref.read(UserRepository.provider),
        ref.read(SponsorshipPackageRepository.provider),
      ));

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  SubscribeToCurrentUserService(
    this._sessionRepository,
    this._userRepository,
    this._sponsorshipPackageRepository,
  );

  Stream<LinxUser> execute() {
    final userId = _sessionRepository.userId;
    return _userRepository.subscribeToCurrentUser(userId).asyncMap(_map);
  }

  Future<LinxUser> _map(UserDTO domain) async {
    final domainUserInfo = domain.toDomain();
    final networkPackages = await _sponsorshipPackageRepository
        .fetchSponsorshipPackagesByUser(domain.uid);
    final domainPackages = networkPackages.map((e) {
      return e.toDomain(domainUserInfo);
    });

    final user = LinxUser(
      info: domainUserInfo,
      packages: domainPackages.toList(),
      matchPercentage: 0,
    );

    return user;
  }
}
