import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/firebase/firebase_extensions.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class UserRepository {
  static final provider = Provider((ref) {
    return UserRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> initializeUser(
    String uid,
    String type,
    String email,
  ) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).set({
      FirestorePaths.TYPE: type,
      FirestorePaths.CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      FirestorePaths.EMAIL: email,
    });
  }

  Future<void> updateUserInfo({
    required String uid,
    String? name,
    String? phoneNumber,
    String? location,
  }) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update(
      {
        FirestorePaths.NAME: name,
        FirestorePaths.PHONE_NUMBER: phoneNumber,
        FirestorePaths.LOCATION: location,
      },
    );
  }

  Future<void> updateUserBiography(String uid, String biography) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.BIOGRAPHY: biography});
  }

  Future<void> updateUserInterests(String uid, Set<String> interests) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.INTERESTS: interests.toList()});
  }

  Future<void> updateUserDescriptors(
      String uid, Set<String> descriptors) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.DESCRIPTORS: descriptors.toList()});
  }

  Future<void> updateProfileImages(String uid, String url) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.PROFILE_IMAGES: FieldValue.arrayUnion([url])
    });
  }

  Future<UserDTO> fetchUserProfile(String uid) async {
    return await _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        var obj = snapshot.data() as Map<String, dynamic>;
        return UserDTO(
          uid: uid,
          displayName: obj[FirestorePaths.NAME] ?? "",
          type: obj[FirestorePaths.TYPE] ?? "",
          location: obj[FirestorePaths.LOCATION] ?? "",
          phoneNumber: obj[FirestorePaths.PHONE_NUMBER] ?? "",
          biography: obj[FirestorePaths.BIOGRAPHY] ?? "",
          interests: ((obj[FirestorePaths.INTERESTS] ?? []) as List<dynamic>)
              .toStrList(),
          descriptors:
              ((obj[FirestorePaths.DESCRIPTORS] ?? []) as List<dynamic>)
                  .toStrList(),
          packages: ((obj[FirestorePaths.PACKAGES] ?? []) as List<dynamic>)
              .toStrList(),
          profileImageUrls:
              ((obj[FirestorePaths.PROFILE_IMAGES] ?? []) as List<dynamic>)
                  .toStrList(),
        );
      },
    );
  }

  Future<void> updateUserSponsorshipPackages(
    String uid,
    List<String> packages,
  ) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.PACKAGES: FieldValue.arrayUnion(packages)});
  }
}
