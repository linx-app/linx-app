import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class UserRepository {
  static final provider = Provider((ref) {
    return UserRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> updateUserInfo({
    required String uid,
    String? name,
    String? phoneNumber,
    String? location
  }) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.NAME: name,
      FirestorePaths.PHONE_NUMBER: phoneNumber,
      FirestorePaths.LOCATION: location
    });
  }

  Future<void> updateUserInterests(String uid, Set<String> chips) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.INTERESTS: chips.toList()
    });
  }

  Future<void> updateUserDescriptors(String uid, Set<String> chips) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.DESCRIPTORS: chips.toList()
    });
  }
  
  Future<void> updateProfileImages(String uid, String url) async {
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.PROFILE_IMAGES: FieldValue.arrayUnion([url])
    });
  }
}