import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/firestore_user.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class UserRepository {
  static final provider = Provider((ref) {
    return UserRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> updateUserInfo(
      {required String uid,
      String? name,
      String? phoneNumber,
      String? location}) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.NAME: name,
      FirestorePaths.PHONE_NUMBER: phoneNumber,
      FirestorePaths.LOCATION: location
    });
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

  Future<FirestoreUser> fetchUserProfile(String uid) async {
    return await _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        var obj = snapshot.data() as Map<String, dynamic>;
        return FirestoreUser(
          uid: uid,
          displayName: obj[FirestorePaths.NAME] as String,
          type: obj[FirestorePaths.TYPE] as String,
          location: obj[FirestorePaths.LOCATION] as String,
          phoneNumber: obj[FirestorePaths.PHONE_NUMBER] as String,
          biography: obj[FirestorePaths.BIOGRAPHY] as String,
          interests: obj[FirestorePaths.INTERESTS] as List<String>,
          descriptors: obj[FirestorePaths.DESCRIPTORS] as List<String>,
          packages: obj[FirestorePaths.PACKAGES] as List<String>,
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
