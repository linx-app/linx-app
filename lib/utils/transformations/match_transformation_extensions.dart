import 'package:linx/features/app/match/data/model/match_dto.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

extension MatchDTOExtensions on MatchDTO {
  Match toDomain(LinxUser user, bool isNew) {
    return Match(
      user: user,
      date: DateTime.fromMicrosecondsSinceEpoch(createdAt),
      isNew: isNew,
    );
  }
}