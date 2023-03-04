import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/pitch_transformation_extensions.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';


class FetchRequestsService {
  static final provider = Provider((ref) => FetchRequestsService(
    ref.read(PitchRepository.provider),
    ref.read(UserRepository.provider),
  ));

  final PitchRepository _pitchRepository;
  final UserRepository _userRepository;

  FetchRequestsService(this._pitchRepository, this._userRepository);

  Future<List<Request>> fetchRequestsWithReceiver(LinxUser user) async {
    var pitches = await _pitchRepository.fetchPitchesWithReceiver(user.uid);

    var sendingUsers = <LinxUser>[];
    for (var pitch in pitches) {
      var networkUser = await _userRepository.fetchUserProfile(pitch.senderId);
      var domainUser = networkUser.toDomain();
      sendingUsers.add(domainUser);
    }

    var requests = <Request>[];
    for (int i = 0; i < pitches.length; i++) {
      requests.add(pitches[i].toDomain(sendingUsers[i], user));
    }
    return requests;
  }
}