import '../entities/cv_analysis.dart';
import '../repositories/cv_repository.dart';

class GetHistoryUseCase {
  final CvRepository _repository;
  GetHistoryUseCase(this._repository);

  Future<List<CvAnalysis>> call() => _repository.getHistory();
}

class DeleteHistoryUseCase {
  final CvRepository _repository;
  DeleteHistoryUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteResult(id);
}

class ClearHistoryUseCase {
  final CvRepository _repository;
  ClearHistoryUseCase(this._repository);

  Future<void> call() => _repository.clearHistory();
}
