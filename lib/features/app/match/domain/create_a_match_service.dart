import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';

class CreateAMatchService {
  static final provider = Provider(
        (ref) =>
        CreateAMatchService(
          ref.read(MatchRepository.provider),
          ref.read(PitchRepository.provider),
        ),
  );

  final MatchRepository _matchRepository;
  final PitchRepository _pitchRepository;

  CreateAMatchService(this._matchRepository, this._pitchRepository);

  Future<void> execute({
    required Request request,
  }) async {
    await _matchRepository.addMatch(
      businessId: request.receiver.info.uid,
      clubId: request.sender.info.uid,
      createdAt: DateTime.now().millisecondsSinceEpoch
    );

    await _pitchRepository.changeMatchFlag(request.id);
  }
}
