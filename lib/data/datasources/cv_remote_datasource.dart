import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import '../models/cv_analysis_model.dart';

/// Handles the remote API calls to Groq.
class CvRemoteDataSource {
  /// Extract text from a job description image using Groq vision model.
  Future<String> extractTextFromImage(Uint8List imageBytes, String mimeType, String apiKey) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(AppStrings.groqUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': AppStrings.groqVisionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': 'Extract ALL text from this job description image. Return ONLY the raw text content exactly as it appears, preserving the structure. Do not add any commentary or formatting.',
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mimeType;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'temperature': 0.1,
        'max_tokens': 4096,
      }),
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw Exception('Image processing timed out. Please try again.'),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Invalid API Key.');
      }
      final body = jsonDecode(response.body);
      final message = body['error']?['message'] ?? 'Unknown error (${response.statusCode})';
      throw Exception('Vision API Error: $message');
    }

    final body = jsonDecode(response.body);
    final choices = body['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No response received. Please try again.');
    }

    return choices[0]['message']?['content'] as String? ?? '';
  }

  /// Analyze CV with optional job description and cover letter context.
  Future<CvAnalysisModel> analyzeCv(
    String cvText,
    String apiKey, {
    String? jobDescription,
    String? coverLetterText,
  }) async {
    final hasJD = jobDescription != null && jobDescription.isNotEmpty;
    final hasCL = coverLetterText != null && coverLetterText.isNotEmpty;

    final systemPrompt = AppStrings.buildSystemPrompt(
      hasJobDescription: hasJD,
      hasCoverLetter: hasCL,
    );

    final userMessageBuffer = StringBuffer();
    userMessageBuffer.writeln('Please analyze this CV thoroughly and return the JSON response:\n');
    userMessageBuffer.writeln('=== CV/RESUME ===');
    userMessageBuffer.writeln(cvText);

    if (hasJD) {
      userMessageBuffer.writeln('\n=== JOB DESCRIPTION ===');
      userMessageBuffer.writeln(jobDescription);
    }

    if (hasCL) {
      userMessageBuffer.writeln('\n=== CANDIDATE\'S COVER LETTER (for review) ===');
      userMessageBuffer.writeln(coverLetterText);
    }

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
            'content': systemPrompt,
          },
          {
            'role': 'user',
            'content': userMessageBuffer.toString(),
          },
        ],
        'temperature': 0.4,
        'max_tokens': 32768,
        'response_format': {'type': 'json_object'},
      }),
    ).timeout(
      const Duration(seconds: 180),
      onTimeout: () => throw Exception('Request timed out. Please try again.'),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your key and update it in Settings.');
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
      throw Exception('No response received. Please try again.');
    }

    String rawText = choices[0]['message']?['content'] as String? ?? '';

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
        throw Exception('Failed to parse response. Please try again.');
      }
    }

    final model = CvAnalysisModel.fromApiJson(
      parsed,
      rawCvText: cvText,
      jobDescriptionText: jobDescription,
      rawCoverLetterText: coverLetterText,
    );

    if (_isPlaceholderText(model.correctedCvText)) {
      final builtCv = _buildCorrectedCvFromCorrections(cvText, model.corrections, model.proposedChanges);
      return CvAnalysisModel(
        id: model.id,
        candidateName: model.candidateName,
        jobTitle: model.jobTitle,
        atsScore: model.atsScore,
        atsVerdict: model.atsVerdict,
        impactScore: model.impactScore,
        readabilityScore: model.readabilityScore,
        completenessScore: model.completenessScore,
        overallSummary: model.overallSummary,
        strengths: model.strengths,
        criticalIssues: model.criticalIssues,
        corrections: model.corrections,
        keywordsPresent: model.keywordsPresent,
        keywordsMissing: model.keywordsMissing,
        skillsAnalysis: model.skillsAnalysis,
        experienceGaps: model.experienceGaps,
        coverLetter: model.coverLetter,
        linkedinSummary: model.linkedinSummary,
        elevatorPitch: model.elevatorPitch,
        interviewPrep: model.interviewPrep,
        quickWins: model.quickWins,
        salaryRange: model.salaryRange,
        careerLevel: model.careerLevel,
        analyzedAt: model.analyzedAt,
        rawCvText: model.rawCvText,
        proposedChanges: model.proposedChanges,
        correctedCvText: builtCv,
        jobDescriptionText: model.jobDescriptionText,
        rawCoverLetterText: model.rawCoverLetterText,
        jobMatchAnalysis: model.jobMatchAnalysis,
        companyResearch: model.companyResearch,
        coverLetterReview: model.coverLetterReview,
        tailoredCoverLetter: model.tailoredCoverLetter,
        followUpEmail: model.followUpEmail,
        networkingMessage: model.networkingMessage,
        learningPath: model.learningPath,
        salaryNegotiation: model.salaryNegotiation,
        interviewQA: model.interviewQA,
      );
    }

    return model;
  }

  bool _isPlaceholderText(String text) {
    if (text.trim().isEmpty) return true;
    final lower = text.toLowerCase();
    const placeholderPhrases = [
      'too long',
      'cannot be included',
      'please note',
      'corrections and proposed changes',
      'revised version',
      'not included',
      'refer to the corrections',
      'apply the corrections',
      'use the corrections',
    ];
    return placeholderPhrases.any((phrase) => lower.contains(phrase));
  }

  String _buildCorrectedCvFromCorrections(
    String originalCv,
    List<CvCorrectionModel> corrections,
    List<ProposedChangeModel> proposedChanges,
  ) {
    var result = originalCv;

    for (final change in proposedChanges) {
      if (change.currentText.isNotEmpty && change.suggestedText.isNotEmpty) {
        result = _replaceNextOccurrence(result, change.currentText, change.suggestedText);
      }
    }

    for (final correction in corrections) {
      if (correction.original.isNotEmpty && correction.corrected.isNotEmpty) {
        result = _replaceNextOccurrence(result, correction.original, correction.corrected);
      }
    }

    return result;
  }

  String _replaceNextOccurrence(String source, String from, String to) {
    final buffer = StringBuffer();
    var searchStart = 0;

    while (true) {
      final index = source.indexOf(from, searchStart);
      if (index == -1) {
        buffer.write(source.substring(searchStart));
        break;
      }
      buffer.write(source.substring(searchStart, index));
      buffer.write(to);
      searchStart = index + from.length;
    }

    return buffer.toString();
  }
}
