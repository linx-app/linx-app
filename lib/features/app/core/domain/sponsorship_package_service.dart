import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class SponsorshipPackageService {
  static final provider = Provider((ref) {
    return SponsorshipPackageService(
      ref.read(SponsorshipPackageRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  final SponsorshipPackageRepository _sponsorshipPackageRepository;
  final UserRepository _userRepository;

  SponsorshipPackageService(
    this._sponsorshipPackageRepository,
    this._userRepository,
  );

  Future<void> updateSponsorshipPackages(
    List<SponsorshipPackage> packages,
  ) async {
    await _sponsorshipPackageRepository.updateSponsorshipPackages(packages);
  }

  Future<List<SponsorshipPackage>> fetchSponsorshipPackageByUser(
    String userId,
  ) async {
    var networkPackages = await _sponsorshipPackageRepository
        .fetchSponsorshipPackagesByUser(userId);

    var users = <LinxUser>[];
    for (var package in networkPackages) {
      var networkUser = await _userRepository.fetchUserProfile(package.userId);
      var domainUser = networkUser.toDomain();
      users.add(domainUser);
    }

    var domainPackages = <SponsorshipPackage>[];
    for (int i = 0; i < networkPackages.length; i++) {
      domainPackages.add(networkPackages[i].toDomain(users[i]));
    }
    return domainPackages;
  }
}
