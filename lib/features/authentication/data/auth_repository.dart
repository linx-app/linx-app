import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class AuthRepository {
  static final provider = Provider<AuthRepository>((ref) {
    return AuthRepository(
        ref.read(firebaseAuthProvider),
        ref.read(firestoreProvider)
    );
  });

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Stream<User?> authStateChange() => _auth.authStateChanges();

  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential creds = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? userId = creds.user?.uid;

    if (userId == null) {
      return AuthFailure();
    } else {
      return AuthSuccess(userId: userId);
    }
  }

  Future<AuthResponse> createUserWithEmailAndPassword(
    String email,
    String password,
    String type,
  ) async {
    UserCredential creds = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? userId = creds.user?.uid;

    if (userId == null) {
      return AuthFailure();
    } else {
      _firestore.collection(FirestorePaths.USERS).doc(userId).set({
        FirestorePaths.TYPE: type,
        FirestorePaths.CREATED_AT: DateTime.now().millisecondsSinceEpoch,
        FirestorePaths.EMAIL: email,
      });
      return AuthSuccess(userId: userId);
    }
  }
}
