import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/cv_analysis.dart';
import '../../domain/usecases/analyze_cv_usecase.dart';
import '../../domain/usecases/history_usecases.dart';
import '../../domain/usecases/settings_usecases.dart';

enum AnalysisState { idle, loading, success, error }

class CvProvider with ChangeNotifier {
  final AnalyzeCvUseCase _analyzeCvUseCase;
  final ExtractImageTextUseCase _extractImageTextUseCase;
  final GetHistoryUseCase _getHistoryUseCase;
  final DeleteHistoryUseCase _deleteHistoryUseCase;
  final ClearHistoryUseCase _clearHistoryUseCase;
  final GetApiKeyUseCase _getApiKeyUseCase;
  final SaveApiKeyUseCase _saveApiKeyUseCase;

  CvProvider({
    required AnalyzeCvUseCase analyzeCvUseCase,
    required ExtractImageTextUseCase extractImageTextUseCase,
    required GetHistoryUseCase getHistoryUseCase,
    required DeleteHistoryUseCase deleteHistoryUseCase,
    required ClearHistoryUseCase clearHistoryUseCase,
    required GetApiKeyUseCase getApiKeyUseCase,
    required SaveApiKeyUseCase saveApiKeyUseCase,
  })  : _analyzeCvUseCase = analyzeCvUseCase,
        _extractImageTextUseCase = extractImageTextUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        _deleteHistoryUseCase = deleteHistoryUseCase,
        _clearHistoryUseCase = clearHistoryUseCase,
        _getApiKeyUseCase = getApiKeyUseCase,
        _saveApiKeyUseCase = saveApiKeyUseCase;

  // --- State ---
  String _apiKey = '';
  String _cvText = '';
  AnalysisState _state = AnalysisState.idle;
  String _errorMessage = '';
  String _loadingMessage = 'Preparing analysis...';
  CvAnalysis? _currentResult;
  List<CvAnalysis> _history = [];
  String _fileName = '';

  // New input state
  String _jobDescriptionText = '';
  Uint8List? _jdImageBytes;
  String _jdImageMimeType = '';
  String _jdImageName = '';
  String _coverLetterText = '';
  String _coverLetterFileName = '';
  bool _isExtractingImage = false;

  // --- Getters ---
  String get apiKey => _apiKey;
  String get cvText => _cvText;
  AnalysisState get state => _state;
  String get errorMessage => _errorMessage;
  String get loadingMessage => _loadingMessage;
  CvAnalysis? get currentResult => _currentResult;
  List<CvAnalysis> get history => _history;
  bool get hasCvText => _cvText.isNotEmpty;
  String get fileName => _fileName;

  String get jobDescriptionText => _jobDescriptionText;
  Uint8List? get jdImageBytes => _jdImageBytes;
  String get jdImageName => _jdImageName;
  String get coverLetterText => _coverLetterText;
  String get coverLetterFileName => _coverLetterFileName;
  bool get hasJobDescription => _jobDescriptionText.isNotEmpty;
  bool get hasCoverLetter => _coverLetterText.isNotEmpty;
  bool get hasJdImage => _jdImageBytes != null;
  bool get isExtractingImage => _isExtractingImage;

  // --- Setters ---
  void setCvText(String text, {String? fileName}) {
    _cvText = text;
    if (fileName != null) _fileName = fileName;
    notifyListeners();
  }

  void clearCvText() {
    _cvText = '';
    _fileName = '';
    notifyListeners();
  }

  void setJobDescription(String text) {
    _jobDescriptionText = text;
    notifyListeners();
  }

  void clearJobDescription() {
    _jobDescriptionText = '';
    _jdImageBytes = null;
    _jdImageMimeType = '';
    _jdImageName = '';
    notifyListeners();
  }

  void setJdImage(Uint8List bytes, String name, String mimeType) {
    _jdImageBytes = bytes;
    _jdImageName = name;
    _jdImageMimeType = mimeType;
    notifyListeners();
  }

  void setCoverLetterText(String text, {String? fileName}) {
    _coverLetterText = text;
    if (fileName != null) _coverLetterFileName = fileName;
    notifyListeners();
  }

  void clearCoverLetter() {
    _coverLetterText = '';
    _coverLetterFileName = '';
    notifyListeners();
  }

  void reset() {
    _state = AnalysisState.idle;
    _errorMessage = '';
    _currentResult = null;
    notifyListeners();
  }

  // --- Actions ---
  Future<void> init() async {
    final saved = await _getApiKeyUseCase() ?? '';
    _apiKey = saved.isNotEmpty ? saved : AppStrings.defaultApiKey;
    _history = await _getHistoryUseCase();
    notifyListeners();
  }

  Future<void> saveApiKey(String key) async {
    await _saveApiKeyUseCase(key);
    _apiKey = key;
    notifyListeners();
  }

  /// Extract text from a JD screenshot.
  Future<void> extractTextFromJdImage() async {
    if (_jdImageBytes == null || _apiKey.isEmpty) return;

    _isExtractingImage = true;
    notifyListeners();

    try {
      final extractedText = await _extractImageTextUseCase(_jdImageBytes!, _jdImageMimeType, _apiKey);
      _jobDescriptionText = extractedText;
      _isExtractingImage = false;
      notifyListeners();
    } catch (e) {
      _isExtractingImage = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> analyzeCV() async {
    if (_cvText.isEmpty) return;

    if (_apiKey.isEmpty) {
      _errorMessage = 'No API Key found. Please go to Settings and enter your API Key.';
      _state = AnalysisState.error;
      notifyListeners();
      return;
    }

    _state = AnalysisState.loading;
    _errorMessage = '';
    _loadingMessage = 'Processing your documents...';
    notifyListeners();

    try {
      _loadingMessage = hasJobDescription
          ? 'Matching CV against job description...'
          : 'Running deep analysis...';
      notifyListeners();

      _currentResult = await _analyzeCvUseCase(
        _cvText,
        _apiKey,
        jobDescription: hasJobDescription ? _jobDescriptionText : null,
        coverLetterText: hasCoverLetter ? _coverLetterText : null,
      );

      _history = await _getHistoryUseCase();
      _state = AnalysisState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = AnalysisState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteHistory(String id) async {
    await _deleteHistoryUseCase(id);
    _history.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _clearHistoryUseCase();
    _history.clear();
    notifyListeners();
  }

  void viewResultFromHistory(CvAnalysis result) {
    _currentResult = result;
    _state = AnalysisState.success;
    notifyListeners();
  }

  void prepareRedoAnalysis(CvAnalysis old) {
    _state = AnalysisState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
