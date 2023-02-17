import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/data/match_repository.dart';
import 'package:linx/features/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class MatchService {
  static final provider = Provider((ref) => MatchService(
        ref.read(MatchRepository.provider),
        ref.read(SponsorshipPackageRepository.provider),
      ));

  final MatchRepository _matchRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  MatchService(this._matchRepository, this._sponsorshipPackageRepository);

  Future<List<LinxUser>> fetchUserInterests(Set<String> interests, ) async {
    var networkUsers = await _matchRepository.fetchUserInterests(3, interests);
    return networkUsers
        .map((user) => LinxUser(
              uid: user.uid,
              displayName: user.displayName,
              email: user.email,
              phoneNumber: user.phoneNumber,
              type: UserType.values.firstWhere((e) => e.name == user.type),
              biography: user.biography,
              location: user.location,
              interests: user.interests.toSet(),
              descriptors: user.descriptors.toSet(),
              // packages: await _sponsorshipPackageRepository
              //     .fetchSponsorshipPackages(e.packages),
              profileImageUrls: user.profileImageUrls,
            ))
        .toList();
  }
}
