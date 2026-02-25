/// Abstract contract for app settings (API key management).
abstract class SettingsRepository {
  Future<String?> getApiKey();
  Future<void> saveApiKey(String key);
  Future<void> clearApiKey();
}
