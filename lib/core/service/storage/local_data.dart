import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKey {
  token('token'),
  name('user_name'),
  email('user_email'),
  userId('userId'),
  profileCompleted('profile_completed'),
  age('age'),
  role('role'),
  image('user_image_path'),
  onboard('onboard'),
  noteCache('expense_note_cache'),
  isProfileComplete('isProfileComplete'),
  isAgreed('isAgreed'),
  isApproved('isApproved'),
  profileImage('profile_image');
  final String key;
  const PreferenceKey(this.key);
}

class LocalService {
  // Generic setter for String, int, bool, double
  Future<void> setValue<T>(PreferenceKey prefKey, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(prefKey.key, value);
    } else if (value is int) {
      await prefs.setInt(prefKey.key, value);
    } else if (value is bool) {
      await prefs.setBool(prefKey.key, value);
    } else if (value is double) {
      await prefs.setDouble(prefKey.key, value);
    } else {
      throw Exception(
        'Unsupported type for key: ${prefKey.key}. Supported types: String, int, bool, double',
      );
    }
  }

  // Generic getter for String, int, bool, double
  Future<T?> getValue<T>(PreferenceKey prefKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == String) {
      return prefs.getString(prefKey.key) as T?;
    } else if (T == int) {
      return prefs.getInt(prefKey.key) as T?;
    } else if (T == bool) {
      return prefs.getBool(prefKey.key) as T?;
    } else if (T == double) {
      return prefs.getDouble(prefKey.key) as T?;
    } else {
      throw Exception(
        'Unsupported type for key: ${prefKey.key}. Supported types: String, int, bool, double',
      );
    }
  }

  // Clear all user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    for (final prefKey in PreferenceKey.values) {
      await prefs.remove(prefKey.key);
    }
  }
}
