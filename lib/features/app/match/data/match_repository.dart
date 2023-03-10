import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/data/model/match_dto.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class MatchRepository {
  static final provider =
      Provider((ref) => MatchRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  MatchRepository(this._firestore);

  Future<List<UserDTO>> fetchUsersWithMatchingInterests(UserInfo user) async {
    final type = user.isClub() ? UserType.business : UserType.club;
    var interests = user.interests.take(10).toList();
    return await _firestore
        .collection(FirestorePaths.USERS)
        .where(FirestorePaths.INTERESTS, arrayContainsAny: interests)
        .where(FirestorePaths.TYPE, isEqualTo: type.name)
        .get()
        .then((QuerySnapshot query) => _mapQueryToUserDTO(query, user));
  }

  Future<String> addMatch({
    required String businessId,
    required String clubId,
    required int createdAt,
  }) async {
    final data = {
      FirestorePaths.BUSINESS: businessId,
      FirestorePaths.CLUB: clubId,
      FirestorePaths.CREATED_AT: createdAt,
      FirestorePaths.IS_NEW: true
    };
    return await _firestore
        .collection(FirestorePaths.MATCHES)
        .add(data)
        .then((doc) => doc.id);
  }

  List<UserDTO> _mapQueryToUserDTO(QuerySnapshot query, UserInfo user) {
    var list = <UserDTO>[];

    for (var element in query.docs) {
      if (element.id != user.uid && !user.pitchesTo.contains(element.id)) {
        var obj = element.data() as Map<String, dynamic>;
        list.add(UserDTO.fromNetwork(element.id, obj));
      }
    }

    return list;
  }

  Future<List<MatchDTO>> fetchMatches(UserInfo user) async {
    final userTypeField = user.isClub() ? FirestorePaths.CLUB : FirestorePaths.BUSINESS;
    return await _firestore
        .collection(FirestorePaths.MATCHES)
        .where(userTypeField, isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot query) => _mapQueryToMatchDTO(query));
  }

  List<MatchDTO> _mapQueryToMatchDTO(QuerySnapshot query) {
    final list = <MatchDTO>[];

    for (final element in query.docs) {
        final obj = element.data() as Map<String, dynamic>;
        list.add(MatchDTO.fromNetwork(element.id, obj));
    }

    return list;
  }
}
