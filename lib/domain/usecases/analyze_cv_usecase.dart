import '../entities/cv_analysis.dart';
import '../repositories/cv_repository.dart';

class AnalyzeCvUseCase {
  final CvRepository _repository;

  AnalyzeCvUseCase(this._repository);

  /// Validates input, calls analysis, saves result, and returns it.
  Future<CvAnalysis> call(
    String cvText,
    String apiKey, {
    String? jobDescription,
    String? coverLetterText,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('Please add your API key in Settings.');
    }
    if (cvText.trim().length < 50) {
      throw Exception('CV text is too short. Please provide a complete CV.');
    }

    final result = await _repository.analyzeCv(
      cvText,
      apiKey,
      jobDescription: jobDescription,
      coverLetterText: coverLetterText,
    );
    await _repository.saveResult(result);
    return result;
  }
}

class ExtractImageTextUseCase {
  final CvRepository _repository;

  ExtractImageTextUseCase(this._repository);

  Future<String> call(String imagePath, String apiKey) async {
    if (apiKey.isEmpty) {
      throw Exception('Please add your API key in Settings.');
    }
    return await _repository.extractTextFromImage(imagePath, apiKey);
  }
}
