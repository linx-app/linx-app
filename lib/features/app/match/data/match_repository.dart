import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class MatchRepository {
  static final provider =
      Provider((ref) => MatchRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  MatchRepository(this._firestore);

  Future<List<UserDTO>> fetchUsersWithMatchingInterests(LinxUser user) async {
    final type = user.isClub() ? UserType.business : UserType.club;
    var interests = user.interests.take(10).toList();
    return await _firestore
        .collection(FirestorePaths.USERS)
        .where(FirestorePaths.INTERESTS, arrayContainsAny: interests)
        .where(FirestorePaths.TYPE, isEqualTo: type.name)
        .get()
        .then((QuerySnapshot query) => _mapQueryToUserDTO(query, user));
  }

  Future<void> addMatch({
    required String businessId,
    required String clubId,
    required int createdAt,
  }) async {
    var data = {
      FirestorePaths.BUSINESS: businessId,
      FirestorePaths.CLUB: clubId,
      FirestorePaths.CREATED_AT: createdAt
    };
    await _firestore.collection(FirestorePaths.MATCHES).add(data);
  }

  List<UserDTO> _mapQueryToUserDTO(QuerySnapshot query, LinxUser user) {
    var list = <UserDTO>[];

    for (var element in query.docs) {
      if (element.id != user.uid && !user.pitchesTo.contains(element.id)) {
        var obj = element.data() as Map<String, dynamic>;
        list.add(UserDTO.fromNetwork(element.id, obj));
      }
    }

    return list;
  }
}
