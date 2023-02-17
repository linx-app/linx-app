import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/data/shared_preferences_data_source.dart';
import 'package:linx/features/user/data/local/user_local_data_source.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';

class SessionRepository {
  static final provider = Provider((ref) {
    return SessionRepository(
      ref.read(firebaseAuthProvider),
      ref.read(userLocalDataSourceProvider),
      ref.read(sharedPrefsProvider),
    );
  });

  final UserLocalDataSource _userLocalDataSource;
  final SharedPreferencesDataSource _sharedPreferences;
  final FirebaseAuth _auth;

  SessionRepository(
    this._auth,
    this._userLocalDataSource,
    this._sharedPreferences,
  );

  Stream<bool> isUserLoggedIn() => _auth.authStateChanges().map((e) => e != null);

  String get userId {
    var uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("User id not found");
    } else {
      return uid;
    }
  }

  Future<void> saveUser(UserDTO user) async {
    _userLocalDataSource.insertUser(user);
  }

  Future<UserDTO?> fetchUser() async {
    var uid = await userId;
    return await _userLocalDataSource.fetchUser(uid);
  }

  Future<void> deleteUser() async {
    var uid = await userId;
    await _userLocalDataSource.deleteUser(uid);
  }

  Future<bool> isFirstTimeInApp() async {
    var first = await _sharedPreferences.get<bool>(PREFS_KEY_FIRST_TIME_IN_APP);

    if (first == null || first == true) {
      _sharedPreferences.set(PREFS_KEY_FIRST_TIME_IN_APP, false);
      return true;
    } else {
      return false;
    }
  }
}
