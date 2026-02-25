import 'package:flutter/material.dart';
import '../../domain/entities/cv_analysis.dart';
import '../../domain/usecases/analyze_cv_usecase.dart';
import '../../domain/usecases/history_usecases.dart';
import '../../domain/usecases/settings_usecases.dart';

enum AnalysisState { idle, loading, success, error }

class CvProvider with ChangeNotifier {
  final AnalyzeCvUseCase _analyzeCvUseCase;
  final GetHistoryUseCase _getHistoryUseCase;
  final DeleteHistoryUseCase _deleteHistoryUseCase;
  final ClearHistoryUseCase _clearHistoryUseCase;
  final GetApiKeyUseCase _getApiKeyUseCase;
  final SaveApiKeyUseCase _saveApiKeyUseCase;

  CvProvider({
    required AnalyzeCvUseCase analyzeCvUseCase,
    required GetHistoryUseCase getHistoryUseCase,
    required DeleteHistoryUseCase deleteHistoryUseCase,
    required ClearHistoryUseCase clearHistoryUseCase,
    required GetApiKeyUseCase getApiKeyUseCase,
    required SaveApiKeyUseCase saveApiKeyUseCase,
  })  : _analyzeCvUseCase = analyzeCvUseCase,
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

  void reset() {
    _state = AnalysisState.idle;
    _errorMessage = '';
    _currentResult = null;
    notifyListeners();
  }

  // --- Actions ---
  Future<void> init() async {
    _apiKey = await _getApiKeyUseCase() ?? '';
    _history = await _getHistoryUseCase();
    notifyListeners();
  }

  Future<void> saveApiKey(String key) async {
    await _saveApiKeyUseCase(key);
    _apiKey = key;
    notifyListeners();
  }

  Future<void> analyzeCV() async {
    if (_cvText.isEmpty) return;

    if (_apiKey.isEmpty) {
      _errorMessage = 'No API Key found. Please go to Settings and enter your Groq API Key.';
      _state = AnalysisState.error;
      notifyListeners();
      return;
    }

    _state = AnalysisState.loading;
    _errorMessage = '';
    _loadingMessage = 'Processing CV text...';
    notifyListeners();

    try {
      _loadingMessage = 'Running deep analysis...';
      notifyListeners();

      _currentResult = await _analyzeCvUseCase(_cvText, _apiKey);
      
      // Refresh history
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

  /// Load CV text from a previous analysis and re-analyze it
  void prepareRedoAnalysis(CvAnalysis old) {
    _cvText = old.coverLetter.isNotEmpty ? _cvText : _cvText; // keep current text if available
    // We don't have the original CV text stored, so navigate to home with a message
    _state = AnalysisState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
