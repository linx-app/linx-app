import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/search/data/user_search_repository.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class SearchUsersService {
  static final provider = Provider(
    (ref) => SearchUsersService(
      ref.read(UserSearchRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    ),
  );

  final UserSearchRepository _userSearchRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;
  final UserRepository _userRepository;

  SearchUsersService(this._userSearchRepository, this._userRepository,
      this._sponsorshipPackageRepository);

  Future<UserSearchPage> execute(LinxUser currentUser, String search) async {
    _userRepository.addToRecentSearches(currentUser.uid, search);
    final networkResult = await _userSearchRepository.search(search);

    final filteredUsers = networkResult.users.map((e) => e.toDomain()).toList();

    filteredUsers.removeWhere((e) {
      final isSameUser = e.uid == currentUser.uid;
      final isSameTypeUser = e.type == currentUser.type;
      return isSameUser || isSameTypeUser;
    });

    final packages = <List<SponsorshipPackage>>[];

    for (var user in filteredUsers) {
      final networkPackage = await _sponsorshipPackageRepository
          .fetchSponsorshipPackagesByUser(user.uid);
      final domainPackage =
          networkPackage.map((e) => e.toDomain(user)).toList();
      packages.add(domainPackage);
    }

    final displayUsers = <DisplayUser>[];

    for (int i = 0; i < filteredUsers.length; i++) {
      final user = filteredUsers[i];
      displayUsers.add(
        DisplayUser(
          info: filteredUsers[i],
          matchPercentage: currentUser.findMatchPercent(user).toInt(),
          packages: packages[i],
        ),
      );
    }

    return UserSearchPage(
      users: displayUsers,
      pageKey: networkResult.pageKey,
      nextPageKey: networkResult.nextPageKey,
    );
  }
}
