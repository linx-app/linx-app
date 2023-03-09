import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class MatchService {
  static final provider = Provider(
    (ref) => MatchService(
      ref.read(MatchRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    ),
  );

  final MatchRepository _matchRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  MatchService(this._matchRepository, this._sponsorshipPackageRepository);

  Future<List<DisplayUser>> fetchUsersWithMatchingInterests(
    LinxUser currentUser,
  ) async {
    final networkUsers =
        await _matchRepository.fetchUsersWithMatchingInterests(currentUser);
    final domainUsers = networkUsers.map((user) => user.toDomain()).toList();
    domainUsers.sort((a, b) => _compare(currentUser.interests, a, b));

    final filteredUsers = domainUsers.take(10).toList();

    final packages = <List<SponsorshipPackage>>[];

    for (var user in filteredUsers) {
      final package = await _sponsorshipPackageRepository
          .fetchSponsorshipPackagesByUser(user.uid);
      final domain = package.map((e) => e.toDomain(user)).toList();
      packages.add(domain);
    }

    final displayUsers = <DisplayUser>[];

    for (int i = 0; i < filteredUsers.length; i++) {
      final user = filteredUsers[i];
      displayUsers.add(
        DisplayUser(
          info: user,
          matchPercentage: currentUser.findMatchPercent(user).toInt(),
          packages: packages[i],
        ),
      );
    }

    return displayUsers;
  }

  int _compare(Set<String> current, LinxUser a, LinxUser b) {
    var aValue = current.intersection(a.descriptors).length;
    var bValue = current.intersection(b.descriptors).length;
    return aValue.compareTo(bValue);
  }
}
