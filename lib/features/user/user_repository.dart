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
    _firestore.collection(FirestorePaths.USERS).doc(uid).set({
      FirestorePaths.NAME: name,
      FirestorePaths.PHONE_NUMBER: phoneNumber,
      FirestorePaths.LOCATION: location
    });
  }
}