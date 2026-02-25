import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import '../models/cv_analysis_model.dart';

/// Handles the remote API call to Groq.
class CvRemoteDataSource {
  Future<CvAnalysisModel> analyzeCv(String cvText, String apiKey) async {
    final response = await http.post(
      Uri.parse(AppStrings.groqUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': AppStrings.groqModel,
        'messages': [
          {
            'role': 'system',
            'content': AppStrings.systemPrompt,
          },
          {
            'role': 'user',
            'content': 'Please analyze this CV thoroughly and return the JSON response:\n\n$cvText',
          },
        ],
        'temperature': 0.7,
        'max_tokens': 8192,
        'response_format': {'type': 'json_object'},
      }),
    ).timeout(
      const Duration(seconds: 90),
      onTimeout: () => throw Exception('Request timed out. Please try again.'),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your Groq console and update it in Settings.');
      }
      if (response.statusCode == 403) {
        throw Exception('Forbidden: Your API key might not have permission for this model or operation.');
      }
      final body = jsonDecode(response.body);
      final message =
          body['error']?['message'] ?? 'Unknown error (${response.statusCode})';
      throw Exception('API Error: $message');
    }

    final body = jsonDecode(response.body);
    final choices = body['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No response from Groq. Please try again.');
    }

    String rawText = choices[0]['message']?['content'] as String? ?? '';

    // Strip markdown fences if present
    String jsonStr = rawText.trim();
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr
          .replaceAll(RegExp(r'```json?\n?'), '')
          .replaceAll('```', '')
          .trim();
    }

    Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(jsonStr);
    } catch (e) {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(jsonStr);
      if (jsonMatch != null) {
        parsed = jsonDecode(jsonMatch.group(0)!);
      } else {
        throw Exception('Failed to parse AI response. Please try again.');
      }
    }

    return CvAnalysisModel.fromApiJson(parsed, rawCvText: cvText);
  }
}
