import 'package:linx/firebase/firestore_paths.dart';

class MatchDTO {
  final String matchId;
  final String clubId;
  final String businessId;
  final int createdAt;

  MatchDTO({
    required this.matchId,
    required this.clubId,
    required this.businessId,
    required this.createdAt,
  });

  static MatchDTO fromNetwork(String matchId, Map<String, dynamic> map) {
    return MatchDTO(
      matchId: matchId,
      clubId: map[FirestorePaths.CLUB] ?? "",
      businessId: map[FirestorePaths.BUSINESS] ?? "",
      createdAt: map[FirestorePaths.CREATED_AT] ?? 0,
    );
  }
}
