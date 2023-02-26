import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/firebase/firebase_extensions.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class MatchRepository {
  static final provider =
      Provider((ref) => MatchRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  MatchRepository(this._firestore);

  Future<List<UserDTO>> fetchUsersWithMatchingInterests(
    Set<String> interests,
  ) async {
    return await _firestore
        .collection(FirestorePaths.USERS)
        .where(FirestorePaths.DESCRIPTORS, arrayContainsAny: interests.toList())
        .where(FirestorePaths.TYPE, isEqualTo: UserType.business.name)
        .get()
        .then((QuerySnapshot query) => _mapQueryToUserDTO(query));
  }

  List<UserDTO> _mapQueryToUserDTO(QuerySnapshot query) {
    var list = <UserDTO>[];

    for (var element in query.docs) {
      var obj = element.data() as Map<String, dynamic>;
      list.add(UserDTO(
        uid: obj[FirestorePaths.USER_ID] ?? "",
        displayName: obj[FirestorePaths.NAME] ?? "",
        type: obj[FirestorePaths.TYPE] ?? "",
        location: obj[FirestorePaths.LOCATION] ?? "",
        phoneNumber: obj[FirestorePaths.PHONE_NUMBER] ?? "",
        biography: obj[FirestorePaths.BIOGRAPHY] ?? "",
        interests: ((obj[FirestorePaths.INTERESTS] ?? []) as List<dynamic>)
            .toStrList(),
        descriptors: ((obj[FirestorePaths.DESCRIPTORS] ?? []) as List<dynamic>)
            .toStrList(),
        packages:
            ((obj[FirestorePaths.PACKAGES] ?? []) as List<dynamic>).toStrList(),
        profileImageUrls:
            ((obj[FirestorePaths.PROFILE_IMAGES] ?? []) as List<dynamic>)
                .toStrList(),
      ),);
    }

    return list;
  }
}
