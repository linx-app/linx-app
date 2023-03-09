import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchSameLocationUsersService {
  static final provider = Provider(
    (ref) => FetchSameLocationUsersService(
      ref.read(UserRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    ),
  );

  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  FetchSameLocationUsersService(
    this._userRepository,
    this._sponsorshipPackageRepository,
  );

  Future<List<SearchGroup>> execute(UserInfo currentUser) async {
    final targetType = currentUser.isClub() ? UserType.business : UserType.club;
    final networkUsers = await _userRepository.fetchMatchingLocationUsers(
      currentUser.location,
      targetType,
    );
    final domainUsers = networkUsers.map((e) => e.toDomain());

    final categories = <String, Set<DisplayUser>>{};

    for (var user in domainUsers) {
      final packages = await _fetchPackages(user);
      final percentage = currentUser.findMatchPercent(user);
      for (var descriptor in user.descriptors) {
        final displayUser = DisplayUser(
          info: user,
          packages: packages,
          matchPercentage: percentage.toInt(),
        );
        if (categories[descriptor] == null) categories[descriptor] = {};
        categories[descriptor]?.add(displayUser);
      }
    }

    var searchGroups = <SearchGroup>[];
    categories.forEach((key, value) {
      searchGroups.add(SearchGroup(category: key, users: value));
    });

    return searchGroups;
  }

  Future<List<SponsorshipPackage>> _fetchPackages(UserInfo user) async {
    final network = await _sponsorshipPackageRepository
        .fetchSponsorshipPackagesByUser(user.uid);
    return network.map((e) => e.toDomain(user)).toList();
  }
}
