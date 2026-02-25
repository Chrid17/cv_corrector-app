import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../models/cv_analysis_model.dart';

/// Handles local persistence via SharedPreferences.
class CvLocalDataSource {
  static const int _maxHistory = 20;

  Future<List<CvAnalysisModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(AppStrings.historyPref) ?? [];
    final results = <CvAnalysisModel>[];
    for (final item in raw) {
      final result = CvAnalysisModel.fromStorageString(item);
      if (result != null) results.add(result);
    }
    results.sort((a, b) => b.analyzedAt.compareTo(a.analyzedAt));
    return results;
  }

  Future<void> saveResult(CvAnalysisModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(AppStrings.historyPref) ?? [];
    raw.insert(0, model.toStorageString());
    final trimmed = raw.take(_maxHistory).toList();
    await prefs.setStringList(AppStrings.historyPref, trimmed);
  }

  Future<void> deleteResult(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(AppStrings.historyPref) ?? [];
    final filtered = raw.where((item) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return map['id'] != id;
      } catch (_) {
        return true;
      }
    }).toList();
    await prefs.setStringList(AppStrings.historyPref, filtered);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.historyPref);
  }
}
