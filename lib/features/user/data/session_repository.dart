import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepository {
  static final provider = Provider((ref) => SessionRepository(ref.read(firebaseAuthProvider)));

  final FirebaseAuth _auth;
  final String _userType = "user_type";

  SessionRepository(this._auth);

  Future<String> getUserId() async {
    var uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User id not found");
    } else {
      return uid;
    }
  }

  Future<void> setUserType(String userType) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_userType, userType);
  }

  Future<String?> getUserType() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userType);
  }

  void clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
