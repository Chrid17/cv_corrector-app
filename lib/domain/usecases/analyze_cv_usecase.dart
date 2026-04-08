import 'dart:typed_data';
import '../entities/cv_analysis.dart';
import '../repositories/cv_repository.dart';

class AnalyzeCvUseCase {
  final CvRepository _repository;

  AnalyzeCvUseCase(this._repository);

  Future<CvAnalysis> call(
    String cvText,
    String apiKey, {
    String? jobDescription,
    String? coverLetterText,
    String? targetIndustry,
    String? targetRole,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('Please add your API key in Settings.');
    }

    final hasCv = cvText.trim().isNotEmpty;
    final hasCoverLetter = coverLetterText != null && coverLetterText.trim().isNotEmpty;

    if (!hasCv && !hasCoverLetter) {
      throw Exception('Please provide a CV or a cover letter to analyze.');
    }

    final result = await _repository.analyzeCv(
      cvText,
      apiKey,
      jobDescription: jobDescription,
      coverLetterText: coverLetterText,
      targetIndustry: targetIndustry,
      targetRole: targetRole,
    );
    await _repository.saveResult(result);
    return result;
  }
}

class ExtractImageTextUseCase {
  final CvRepository _repository;

  ExtractImageTextUseCase(this._repository);

  Future<String> call(Uint8List imageBytes, String mimeType, String apiKey) async {
    if (apiKey.isEmpty) {
      throw Exception('Please add your API key in Settings.');
    }
    return await _repository.extractTextFromImage(imageBytes, mimeType, apiKey);
  }
}
