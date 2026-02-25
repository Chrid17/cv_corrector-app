import '../../domain/entities/cv_analysis.dart';
import '../../domain/repositories/cv_repository.dart';
import '../datasources/cv_remote_datasource.dart';
import '../datasources/cv_local_datasource.dart';
import '../models/cv_analysis_model.dart';

class CvRepositoryImpl implements CvRepository {
  final CvRemoteDataSource _remoteDataSource;
  final CvLocalDataSource _localDataSource;

  CvRepositoryImpl({
    required CvRemoteDataSource remoteDataSource,
    required CvLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<CvAnalysis> analyzeCv(
    String cvText,
    String apiKey, {
    String? jobDescription,
    String? coverLetterText,
  }) async {
    final model = await _remoteDataSource.analyzeCv(
      cvText,
      apiKey,
      jobDescription: jobDescription,
      coverLetterText: coverLetterText,
    );
    return model.toEntity();
  }

  @override
  Future<String> extractTextFromImage(String imagePath, String apiKey) async {
    return await _remoteDataSource.extractTextFromImage(imagePath, apiKey);
  }

  @override
  Future<List<CvAnalysis>> getHistory() async {
    final models = await _localDataSource.loadHistory();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveResult(CvAnalysis result) async {
    final model = CvAnalysisModel.fromEntity(result);
    await _localDataSource.saveResult(model);
  }

  @override
  Future<void> deleteResult(String id) async {
    await _localDataSource.deleteResult(id);
  }

  @override
  Future<void> clearHistory() async {
    await _localDataSource.clearHistory();
  }
}
