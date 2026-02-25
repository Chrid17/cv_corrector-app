import 'dart:typed_data';
import '../entities/cv_analysis.dart';

/// Abstract contract for CV operations.
/// Data layer provides the implementation.
abstract class CvRepository {
  Future<CvAnalysis> analyzeCv(
    String cvText,
    String apiKey, {
    String? jobDescription,
    String? coverLetterText,
  });
  Future<String> extractTextFromImage(Uint8List imageBytes, String mimeType, String apiKey);
  Future<List<CvAnalysis>> getHistory();
  Future<void> saveResult(CvAnalysis result);
  Future<void> deleteResult(String id);
  Future<void> clearHistory();
}
