import '../entities/cv_analysis.dart';
import '../repositories/cv_repository.dart';

class AnalyzeCvUseCase {
  final CvRepository _repository;

  AnalyzeCvUseCase(this._repository);

  /// Validates input, calls analysis, saves result, and returns it.
  Future<CvAnalysis> call(String cvText, String apiKey) async {
    if (apiKey.isEmpty) {
      throw Exception('Please add your Gemini API key in Settings.');
    }
    if (cvText.trim().length < 50) {
      throw Exception('CV text is too short. Please provide a complete CV.');
    }

    final result = await _repository.analyzeCv(cvText, apiKey);
    await _repository.saveResult(result);
    return result;
  }
}
