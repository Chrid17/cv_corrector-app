import '../repositories/settings_repository.dart';

class GetApiKeyUseCase {
  final SettingsRepository _repository;
  GetApiKeyUseCase(this._repository);

  Future<String?> call() => _repository.getApiKey();
}

class SaveApiKeyUseCase {
  final SettingsRepository _repository;
  SaveApiKeyUseCase(this._repository);

  Future<void> call(String key) => _repository.saveApiKey(key);
}

class ClearApiKeyUseCase {
  final SettingsRepository _repository;
  ClearApiKeyUseCase(this._repository);

  Future<void> call() => _repository.clearApiKey();
}
