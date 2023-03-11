import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/package_transformation_extensions.dart';
import 'package:linx/utils/transformations/pitch_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class FetchOutgoingRequestsService {
  static final provider = Provider(
    (ref) => FetchOutgoingRequestsService(
      ref.read(PitchRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(SponsorshipPackageRepository.provider),
    ),
  );

  final PitchRepository _pitchRepository;
  final UserRepository _userRepository;
  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  FetchOutgoingRequestsService(
    this._pitchRepository,
    this._userRepository,
    this._sponsorshipPackageRepository,
  );

  Future<List<Request>> execute(LinxUser sendingUser) async {
    final currentUserId = sendingUser.info.uid;
    final pitches = await _pitchRepository.fetchOutgoingPitches(currentUserId);

    final receivingUsers = <LinxUser>[];

    for (final pitch in pitches) {
      final networkUser =
          await _userRepository.fetchUserProfile(pitch.receiverId);
      final networkPackages = await _sponsorshipPackageRepository
          .fetchSponsorshipPackagesByUser(pitch.receiverId);

      final receivingUser = networkUser.toDomain();
      final domainPackages =
          networkPackages.map((e) => e.toDomain(receivingUser)).toList();

      final displayUser = LinxUser(
        info: receivingUser,
        packages: domainPackages,
        matchPercentage: sendingUser.info.findMatchPercent(receivingUser).toInt(),
      );

      receivingUsers.add(displayUser);
    }

    final requests = <Request>[];
    for (int i = 0; i < pitches.length; i++) {
      requests.add(pitches[i].toDomain(sendingUser, receivingUsers[i]));
    }
    return requests;
  }
}
