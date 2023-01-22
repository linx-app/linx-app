import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => SharedPreferencesDataSource());

const PREFS_KEY_FIRST_TIME_IN_APP = "first_time_in_app";

class SharedPreferencesDataSource {

  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  Future<T?> get<T>(String key) async {
    return (await prefs).get(key) as T?;
  }

  Future<void> set<T>(String key, T value) async {
    if (value is String) {
      (await prefs).setString(key, value);
    } else if (value is bool) {
      (await prefs).setBool(key, value);
    } else if (value is int) {
      (await prefs).setInt(key, value);
    } else if (value is double) {
      (await prefs).setDouble(key, value);
    } else if (value is List<String>) {
      (await prefs).setStringList(key, value);
    } else {
      throw Exception("$value of type $T is not permitted in shared prefs");
    }
  }
}