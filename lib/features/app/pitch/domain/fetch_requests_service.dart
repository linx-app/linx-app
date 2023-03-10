import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/pitch_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchRequestsService {
  static final provider = Provider((ref) => FetchRequestsService(
        ref.read(PitchRepository.provider),
        ref.read(UserRepository.provider),
        ref.read(SponsorshipPackageRepository.provider),
      ));

  final PitchRepository _pitchRepository;
  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  FetchRequestsService(
    this._pitchRepository,
    this._userRepository,
    this._sponsorshipPackageRepository,
  );

  Future<List<Request>> fetchRequestsWithReceiver(LinxUser user) async {
    final uid = user.info.uid;
    var pitches = await _pitchRepository.fetchPitchesWithReceiver(uid);
    pitches = pitches.take(10).toList();

    final sendingUsers = <LinxUser>[];

    for (var pitch in pitches) {
      final networkUser =
          await _userRepository.fetchUserProfile(pitch.senderId);
      final networkPackages = await _sponsorshipPackageRepository
          .fetchSponsorshipPackagesByUser(pitch.senderId);

      final domainUser = networkUser.toDomain();
      final domainPackages =
          networkPackages.map((e) => e.toDomain(domainUser)).toList();
      final displayUser = LinxUser(
        info: domainUser,
        packages: domainPackages,
        matchPercentage: user.info.findMatchPercent(domainUser).toInt(),
      );

      sendingUsers.add(displayUser);
    }

    final requests = <Request>[];
    for (int i = 0; i < pitches.length; i++) {
      requests.add(pitches[i].toDomain(sendingUsers[i], user));
    }
    return requests;
  }
}
