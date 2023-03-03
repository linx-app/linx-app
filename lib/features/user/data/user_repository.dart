import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class UserRepository {
  static final provider = Provider((ref) {
    return UserRepository(
        ref.read(firestoreProvider),
        ref.read(fcmTokenProvider),
    );
  });

  final FirebaseFirestore _firestore;
  final Future<String?> _fcmToken;

  UserRepository(this._firestore, this._fcmToken);

  Future<void> initializeUser({
    required String uid,
    required String type,
    required String email,
  }) async {
    var token = await _fcmToken;
    _firestore.collection(FirestorePaths.USERS).doc(uid).set({
      FirestorePaths.TYPE: type,
      FirestorePaths.CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      FirestorePaths.EMAIL: email,
      FirestorePaths.NOTIFICATION_TOKEN: token == null ? [] : [token],
    });
  }

  Future<void> addFCMToken(String uid) async {
    var token = await _fcmToken;
    if (token == null) return;
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.NOTIFICATION_TOKEN: FieldValue.arrayUnion([token]),
    });
  }

  Future<void> removeFCMToken(String uid) async {
    var token = await _fcmToken;
    if (token == null) return;
    _firestore.collection(FirestorePaths.USERS).doc(uid).update({
      FirestorePaths.NOTIFICATION_TOKEN: FieldValue.arrayRemove([token]),
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
        var data = snapshot.data();
        if (data != null) {
          var obj = snapshot.data() as Map<String, dynamic>;
          return UserDTO.fromNetwork(uid, obj);
        } else {
          throw Exception("Firebase document is null");
        }
      },
    );
  }

  Future<void> updateUserSponsorshipPackageCount(
    String uid,
    int count,
  ) async {
    _firestore
        .collection(FirestorePaths.USERS)
        .doc(uid)
        .update({FirestorePaths.NUMBER_OF_PACKAGES: count});
  }
}
