import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.apiKeyPref);
  }

  @override
  Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.apiKeyPref, key);
  }

  @override
  Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.apiKeyPref);
  }
}
