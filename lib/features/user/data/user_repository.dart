import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
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

  Future<Map<String, dynamic>> fetchUserProfile(String uid) async {
    return await _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    });
  }

  Future<void> updateUserSponsorshipPackages(
    String uid,
    List<SponsorshipPackage> packages,
  ) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.PACKAGES: FieldValue.arrayUnion(packages)});
  }
}
