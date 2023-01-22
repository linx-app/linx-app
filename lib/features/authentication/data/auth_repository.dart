import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/firebase/firebase_providers.dart';

class AuthRepository {
  static final provider = Provider<AuthRepository>((ref) {
    return AuthRepository(ref.read(firebaseAuthProvider));
  });

  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Stream<User?> authStateChange() => _auth.authStateChanges();

  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? userId = creds.user?.uid;
      if (userId == null) {
        return AuthFailure(authMessage: "User ID not found");
      } else {
        return AuthSuccess(userId: userId);
      }
    } on FirebaseAuthException catch (e) {
      return AuthFailure(authMessage: e.message);
    }
  }

  Future<AuthResponse> createUserWithEmailAndPassword(
    String email,
    String password,
    String type,
  ) async {
    try {
      UserCredential creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? userId = creds.user?.uid;

      if (userId == null) {
        return AuthFailure();
      } else {
        return AuthSuccess(userId: userId);
      }
    } on FirebaseAuthException catch (e) {
      return AuthFailure(authMessage: e.message);
    }
  }
}
