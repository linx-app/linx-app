import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/data/match_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class CreateAMatchService {
  static final provider = Provider(
        (ref) =>
        CreateAMatchService(
          ref.read(MatchRepository.provider),
        ),
  );

  final MatchRepository _matchRepository;

  CreateAMatchService(this._matchRepository);

  Future<void> execute({
    required LinxUser business,
    required LinxUser club,
  }) async {
    await _matchRepository.addMatch(
      businessId: business.uid,
      clubId: club.uid,
      createdAt: DateTime.now().millisecondsSinceEpoch
    );
  }
}
