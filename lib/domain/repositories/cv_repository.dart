import '../entities/cv_analysis.dart';

/// Abstract contract for CV operations.
/// Data layer provides the implementation.
abstract class CvRepository {
  Future<CvAnalysis> analyzeCv(String cvText, String apiKey);
  Future<List<CvAnalysis>> getHistory();
  Future<void> saveResult(CvAnalysis result);
  Future<void> deleteResult(String id);
  Future<void> clearHistory();
}
