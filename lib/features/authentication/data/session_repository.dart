import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepository {
  final String _uid = "user_id";
  final String _userType = "user_type";
  final ProviderRef<SessionRepository> _ref;

  SessionRepository(this._ref);

  static final provider =
      Provider<SessionRepository>((ref) => SessionRepository(ref));

  Future<void> setUserId(String uid) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_uid, uid);
  }

  Future<String> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString(_uid);

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
