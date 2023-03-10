import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/match_transformation_extensions.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchMatchesService {
  static final provider = Provider(
    (ref) => FetchMatchesService(
      ref.read(MatchRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    ),
  );

  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  FetchMatchesService(
    this._matchRepository,
    this._userRepository,
    this._sponsorshipPackageRepository,
  );

  Future<List<Match>> execute(UserInfo currentUserInfo) async {
    final isClub = currentUserInfo.isClub();
    final networkMatches = await _matchRepository.fetchMatches(currentUserInfo);

    final users = <LinxUser>[];

    for (final match in networkMatches) {
      final uid = isClub ? match.businessId : match.clubId;
      final userInfo = (await _userRepository.fetchUserProfile(uid)).toDomain();
      final networkPackages = await _sponsorshipPackageRepository
          .fetchSponsorshipPackagesByUser(userInfo.uid);
      final domainPackages = networkPackages.map((e) => e.toDomain(userInfo));

      users.add(
        LinxUser(
          info: userInfo,
          packages: domainPackages.toList(),
          matchPercentage: currentUserInfo.findMatchPercent(userInfo).toInt(),
        ),
      );
    }

    final domainMatches = <Match>[];

    for (var i = 0; i < networkMatches.length; i++) {
      final match = networkMatches[i];
      domainMatches.add(
        match.toDomain(
          users[i],
          currentUserInfo.newMatches.contains(match.matchId),
        ),
      );
    }

    return domainMatches;
  }
}
