import 'dart:convert';
import 'dart:math' as math;
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
        'max_completion_tokens': 4096,
        // Plain text extraction: skip the model's thinking mode.
        'reasoning_effort': 'none',
      }),
    ).timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw Exception('Image processing timed out. Please try again.'),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Invalid API Key.');
      }
      throw Exception('Vision API Error: ${_apiErrorMessage(response)}');
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
    String? targetIndustry,
    String? targetRole,
  }) async {
    final hasCV = cvText.trim().isNotEmpty;
    final hasJD = jobDescription != null && jobDescription.isNotEmpty;
    final hasCL = coverLetterText != null && coverLetterText.isNotEmpty;
    final hasIndustry = targetIndustry != null && targetIndustry.isNotEmpty;
    final hasRole = targetRole != null && targetRole.isNotEmpty;
    final coverLetterOnly = !hasCV && hasCL;

    final systemPrompt = AppStrings.buildSystemPrompt(
      hasJobDescription: hasJD,
      hasCoverLetter: hasCL,
      coverLetterOnly: coverLetterOnly,
      targetIndustry: hasIndustry ? targetIndustry : null,
      targetRole: hasRole ? targetRole : null,
    );

    final userMessageBuffer = StringBuffer();
    if (coverLetterOnly) {
      userMessageBuffer.writeln('Please review this cover letter thoroughly and return the JSON response:\n');
    } else {
      userMessageBuffer.writeln('Please analyze this CV thoroughly and return the JSON response:\n');
    }
    if (hasIndustry || hasRole) {
      userMessageBuffer.writeln('=== TARGET CONTEXT ===');
      if (hasIndustry) userMessageBuffer.writeln('Target Industry: $targetIndustry');
      if (hasRole) userMessageBuffer.writeln('Target Role: $targetRole');
      userMessageBuffer.writeln();
    }
    if (hasCV) {
      userMessageBuffer.writeln('=== CV/RESUME ===');
      userMessageBuffer.writeln(cvText);
    }

    if (hasJD) {
      userMessageBuffer.writeln('\n=== JOB DESCRIPTION ===');
      userMessageBuffer.writeln(jobDescription);
    }

    if (hasCL) {
      userMessageBuffer.writeln('\n=== CANDIDATE\'S COVER LETTER (for review) ===');
      userMessageBuffer.writeln(coverLetterText);
    }

    var userMessage = userMessageBuffer.toString();

    // Groq counts prompt tokens + max_completion_tokens against the
    // per-minute token limit, so input and output share one budget.
    // gpt-oss's tokenizer averages ~4 chars/token on English; 3.6
    // deliberately over-estimates so requests stay under the limit.
    const charsPerToken = 3.6;
    const requestOverheadTokens = 150; // chat template + reasoning preamble
    const minOutputTokens = 4500;
    const maxOutputTokens = 8192;
    const tpmBudget = AppStrings.groqTpmBudget;
    const truncationNote =
        '\n\n[Document truncated to fit analysis limits. Focus on the content provided above.]';

    int estimateInputTokens() =>
        ((systemPrompt.length + userMessage.length) / charsPerToken).ceil() +
        requestOverheadTokens;

    if (estimateInputTokens() + minOutputTokens > tpmBudget) {
      final allowedInputTokens =
          tpmBudget - minOutputTokens - requestOverheadTokens;
      final maxUserChars = (allowedInputTokens * charsPerToken).floor() -
          systemPrompt.length -
          truncationNote.length;
      if (maxUserChars > 500 && userMessage.length > maxUserChars) {
        userMessage = '${userMessage.substring(0, maxUserChars)}$truncationNote';
      }
    }

    // Give the response everything the budget has left after the input.
    final maxTokens = math.max(
      minOutputTokens,
      math.min(maxOutputTokens, tpmBudget - estimateInputTokens()),
    );

    final requestBody = jsonEncode({
      'model': AppStrings.groqModel,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userMessage},
      ],
      'temperature': 0.4,
      'max_completion_tokens': maxTokens,
      // gpt-oss is a reasoning model; its thinking tokens come out of
      // max_completion_tokens, so keep it short to leave room for the JSON.
      'reasoning_effort': 'low',
      'include_reasoning': false,
      'response_format': {'type': 'json_object'},
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    late http.Response response;
    const maxRetries = 3;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      response = await http.post(
        Uri.parse(AppStrings.groqUrl),
        headers: headers,
        body: requestBody,
      ).timeout(
        const Duration(seconds: 180),
        onTimeout: () => throw Exception('Request timed out. Please try again.'),
      );

      if (response.statusCode == 429 && attempt < maxRetries - 1) {
        final retryAfter = int.tryParse(response.headers['retry-after'] ?? '') ?? 15;
        final waitSeconds = retryAfter.clamp(5, 60);
        await Future.delayed(Duration(seconds: waitSeconds));
        continue;
      }
      break;
    }

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your key and update it in Settings.');
      }
      if (response.statusCode == 429) {
        throw Exception('Rate limit reached. Please wait a moment and try again.');
      }
      if (response.statusCode == 413) {
        throw Exception(
            "This document is too long for your Groq plan's per-minute token limit. Shorten the CV or job description and try again.");
      }
      if (_apiErrorCode(response) == 'json_validate_failed') {
        throw Exception(
            'The analysis was cut off before it finished. Please try again, or shorten the CV or job description.');
      }
      throw Exception('API Error: ${_apiErrorMessage(response)}');
    }

    final body = jsonDecode(response.body);
    final choices = body['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No response received. Please try again.');
    }

    final finishReason = choices[0]['finish_reason'] as String?;
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
      Map<String, dynamic>? recovered;
      if (jsonMatch != null) {
        try {
          recovered = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
        } catch (_) {
          recovered = null;
        }
      }
      if (recovered == null) {
        if (finishReason == 'length') {
          throw Exception(
              'The analysis was cut off before it finished. Please try again, or shorten the CV or job description.');
        }
        throw Exception('Failed to parse response. Please try again.');
      }
      parsed = recovered;
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

  Map<String, dynamic>? _apiError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      final error = body is Map ? body['error'] : null;
      return error is Map<String, dynamic> ? error : null;
    } catch (_) {
      return null;
    }
  }

  String? _apiErrorCode(http.Response response) =>
      _apiError(response)?['code'] as String?;

  String _apiErrorMessage(http.Response response) =>
      _apiError(response)?['message'] as String? ??
      'Unknown error (${response.statusCode})';

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
