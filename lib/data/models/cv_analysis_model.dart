import 'dart:convert';
import '../../domain/entities/cv_analysis.dart' as domain;

class SkillsAnalysisModel {
  final List<String> technical;
  final List<String> soft;
  final List<String> missingRecommended;

  SkillsAnalysisModel({
    required this.technical,
    required this.soft,
    required this.missingRecommended,
  });

  factory SkillsAnalysisModel.fromJson(Map<String, dynamic> json) =>
      SkillsAnalysisModel(
        technical: List<String>.from(json['technical'] ?? []),
        soft: List<String>.from(json['soft'] ?? []),
        missingRecommended:
            List<String>.from(json['missing_recommended'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'technical': technical,
        'soft': soft,
        'missing_recommended': missingRecommended,
      };

  domain.SkillsAnalysis toEntity() => domain.SkillsAnalysis(
        technical: technical,
        soft: soft,
        missingRecommended: missingRecommended,
      );

  factory SkillsAnalysisModel.fromEntity(domain.SkillsAnalysis entity) =>
      SkillsAnalysisModel(
        technical: entity.technical,
        soft: entity.soft,
        missingRecommended: entity.missingRecommended,
      );
}

class CvCorrectionModel {
  final String section;
  final String type;
  final String original;
  final String corrected;
  final String reason;
  final String priority;

  CvCorrectionModel({
    required this.section,
    required this.type,
    required this.original,
    required this.corrected,
    required this.reason,
    required this.priority,
  });

  factory CvCorrectionModel.fromJson(Map<String, dynamic> json) =>
      CvCorrectionModel(
        section: json['section'] ?? '',
        type: json['type'] ?? '',
        original: json['original'] ?? '',
        corrected: json['corrected'] ?? '',
        reason: json['reason'] ?? '',
        priority: json['priority'] ?? 'Medium',
      );

  Map<String, dynamic> toJson() => {
        'section': section,
        'type': type,
        'original': original,
        'corrected': corrected,
        'reason': reason,
        'priority': priority,
      };

  domain.CvCorrection toEntity() => domain.CvCorrection(
        section: section,
        type: type,
        original: original,
        corrected: corrected,
        reason: reason,
        priority: priority,
      );

  factory CvCorrectionModel.fromEntity(domain.CvCorrection entity) =>
      CvCorrectionModel(
        section: entity.section,
        type: entity.type,
        original: entity.original,
        corrected: entity.corrected,
        reason: entity.reason,
        priority: entity.priority,
      );
}

class ProposedChangeModel {
  final String section;
  final String currentText;
  final String suggestedText;
  final String rationale;
  final String impact;

  ProposedChangeModel({
    required this.section,
    required this.currentText,
    required this.suggestedText,
    required this.rationale,
    required this.impact,
  });

  factory ProposedChangeModel.fromJson(Map<String, dynamic> json) =>
      ProposedChangeModel(
        section: json['section'] ?? '',
        currentText: json['current_text'] ?? '',
        suggestedText: json['suggested_text'] ?? '',
        rationale: json['rationale'] ?? '',
        impact: json['impact'] ?? 'Medium',
      );

  Map<String, dynamic> toJson() => {
        'section': section,
        'current_text': currentText,
        'suggested_text': suggestedText,
        'rationale': rationale,
        'impact': impact,
      };

  domain.ProposedChange toEntity() => domain.ProposedChange(
        section: section,
        currentText: currentText,
        suggestedText: suggestedText,
        rationale: rationale,
        impact: impact,
      );

  factory ProposedChangeModel.fromEntity(domain.ProposedChange entity) =>
      ProposedChangeModel(
        section: entity.section,
        currentText: entity.currentText,
        suggestedText: entity.suggestedText,
        rationale: entity.rationale,
        impact: entity.impact,
      );
}

class CvAnalysisModel {
  final String id;
  final String candidateName;
  final String jobTitle;
  final int atsScore;
  final String atsVerdict;
  final int impactScore;
  final int readabilityScore;
  final int completenessScore;
  final String overallSummary;
  final List<String> strengths;
  final List<String> criticalIssues;
  final List<CvCorrectionModel> corrections;
  final List<String> keywordsPresent;
  final List<String> keywordsMissing;
  final SkillsAnalysisModel skillsAnalysis;
  final List<String> experienceGaps;
  final String coverLetter;
  final String linkedinSummary;
  final String elevatorPitch;
  final List<String> interviewPrep;
  final List<String> quickWins;
  final String salaryRange;
  final String careerLevel;
  final DateTime analyzedAt;
  final String rawCvText;
  final List<ProposedChangeModel> proposedChanges;

  CvAnalysisModel({
    required this.id,
    required this.candidateName,
    required this.jobTitle,
    required this.atsScore,
    required this.atsVerdict,
    required this.impactScore,
    required this.readabilityScore,
    required this.completenessScore,
    required this.overallSummary,
    required this.strengths,
    required this.criticalIssues,
    required this.corrections,
    required this.keywordsPresent,
    required this.keywordsMissing,
    required this.skillsAnalysis,
    required this.experienceGaps,
    required this.coverLetter,
    required this.linkedinSummary,
    required this.elevatorPitch,
    required this.interviewPrep,
    required this.quickWins,
    required this.salaryRange,
    required this.careerLevel,
    required this.analyzedAt,
    required this.rawCvText,
    required this.proposedChanges,
  });

  factory CvAnalysisModel.fromApiJson(Map<String, dynamic> json,
          {required String rawCvText}) =>
      CvAnalysisModel(
        id: json['id'] ?? '', // Will be updated by repository if empty
        candidateName: json['candidate_name'] ?? 'Unknown',
        jobTitle: json['job_title'] ?? 'Professional',
        atsScore: (json['ats_score'] ?? 0).toInt(),
        atsVerdict: json['ats_verdict'] ?? 'Fair',
        impactScore: (json['impact_score'] ?? 0).toInt(),
        readabilityScore: (json['readability_score'] ?? 0).toInt(),
        completenessScore: (json['completeness_score'] ?? 0).toInt(),
        overallSummary: json['overall_summary'] ?? '',
        strengths: List<String>.from(json['strengths'] ?? []),
        criticalIssues: List<String>.from(json['critical_issues'] ?? []),
        corrections: (json['corrections'] as List? ?? [])
            .map((c) => CvCorrectionModel.fromJson(c))
            .toList(),
        keywordsPresent: List<String>.from(json['keywords_present'] ?? []),
        keywordsMissing: List<String>.from(json['keywords_missing'] ?? []),
        skillsAnalysis:
            SkillsAnalysisModel.fromJson(json['skills_analysis'] ?? {}),
        experienceGaps: List<String>.from(json['experience_gaps'] ?? []),
        coverLetter: json['cover_letter'] ?? '',
        linkedinSummary: json['linkedin_summary'] ?? '',
        elevatorPitch: json['elevator_pitch'] ?? '',
        interviewPrep: List<String>.from(json['interview_prep'] ?? []),
        quickWins: List<String>.from(json['quick_wins'] ?? []),
        salaryRange: json['salary_range'] ?? 'N/A',
        careerLevel: json['career_level'] ?? 'Mid',
        analyzedAt: DateTime.now(),
        rawCvText: rawCvText,
        proposedChanges: (json['proposed_changes'] as List? ?? [])
            .map((p) => ProposedChangeModel.fromJson(p))
            .toList(),
      );

  factory CvAnalysisModel.fromEntity(domain.CvAnalysis entity) =>
      CvAnalysisModel(
        id: entity.id,
        candidateName: entity.candidateName,
        jobTitle: entity.jobTitle,
        atsScore: entity.atsScore,
        atsVerdict: entity.atsVerdict,
        impactScore: entity.impactScore,
        readabilityScore: entity.readabilityScore,
        completenessScore: entity.completenessScore,
        overallSummary: entity.overallSummary,
        strengths: entity.strengths,
        criticalIssues: entity.criticalIssues,
        corrections: entity.corrections
            .map((c) => CvCorrectionModel.fromEntity(c))
            .toList(),
        keywordsPresent: entity.keywordsPresent,
        keywordsMissing: entity.keywordsMissing,
        skillsAnalysis:
            SkillsAnalysisModel.fromEntity(entity.skillsAnalysis),
        experienceGaps: entity.experienceGaps,
        coverLetter: entity.coverLetter,
        linkedinSummary: entity.linkedinSummary,
        elevatorPitch: entity.elevatorPitch,
        interviewPrep: entity.interviewPrep,
        quickWins: entity.quickWins,
        salaryRange: entity.salaryRange,
        careerLevel: entity.careerLevel,
        analyzedAt: entity.analyzedAt,
        rawCvText: entity.rawCvText,
        proposedChanges: entity.proposedChanges
            .map((p) => ProposedChangeModel.fromEntity(p))
            .toList(),
      );

  domain.CvAnalysis toEntity() => domain.CvAnalysis(
        id: id,
        candidateName: candidateName,
        jobTitle: jobTitle,
        atsScore: atsScore,
        atsVerdict: atsVerdict,
        impactScore: impactScore,
        readabilityScore: readabilityScore,
        completenessScore: completenessScore,
        overallSummary: overallSummary,
        strengths: strengths,
        criticalIssues: criticalIssues,
        corrections: corrections.map((c) => c.toEntity()).toList(),
        keywordsPresent: keywordsPresent,
        keywordsMissing: keywordsMissing,
        skillsAnalysis: skillsAnalysis.toEntity(),
        experienceGaps: experienceGaps,
        coverLetter: coverLetter,
        linkedinSummary: linkedinSummary,
        elevatorPitch: elevatorPitch,
        interviewPrep: interviewPrep,
        quickWins: quickWins,
        salaryRange: salaryRange,
        careerLevel: careerLevel,
        analyzedAt: analyzedAt,
        rawCvText: rawCvText,
        proposedChanges: proposedChanges.map((p) => p.toEntity()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'candidate_name': candidateName,
        'job_title': jobTitle,
        'ats_score': atsScore,
        'ats_verdict': atsVerdict,
        'impact_score': impactScore,
        'readability_score': readabilityScore,
        'completeness_score': completenessScore,
        'overall_summary': overallSummary,
        'strengths': strengths,
        'critical_issues': criticalIssues,
        'corrections': corrections.map((c) => c.toJson()).toList(),
        'keywords_present': keywordsPresent,
        'keywords_missing': keywordsMissing,
        'skills_analysis': skillsAnalysis.toJson(),
        'experience_gaps': experienceGaps,
        'cover_letter': coverLetter,
        'linkedin_summary': linkedinSummary,
        'elevator_pitch': elevatorPitch,
        'interview_prep': interviewPrep,
        'quick_wins': quickWins,
        'salary_range': salaryRange,
        'career_level': careerLevel,
        'analyzed_at': analyzedAt.toIso8601String(),
        'raw_cv_text': rawCvText,
        'proposed_changes': proposedChanges.map((p) => p.toJson()).toList(),
      };

  String toStorageString() => jsonEncode(toJson());

  static CvAnalysisModel? fromStorageString(String jsonStr) {
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return CvAnalysisModel(
        id: map['id'] ?? '',
        candidateName: map['candidate_name'] ?? '',
        jobTitle: map['job_title'] ?? '',
        atsScore: (map['ats_score'] ?? 0).toInt(),
        atsVerdict: map['ats_verdict'] ?? '',
        impactScore: (map['impact_score'] ?? 0).toInt(),
        readabilityScore: (map['readability_score'] ?? 0).toInt(),
        completenessScore: (map['completeness_score'] ?? 0).toInt(),
        overallSummary: map['overall_summary'] ?? '',
        strengths: List<String>.from(map['strengths'] ?? []),
        criticalIssues: List<String>.from(map['critical_issues'] ?? []),
        corrections: (map['corrections'] as List? ?? [])
            .map((c) => CvCorrectionModel.fromJson(c))
            .toList(),
        keywordsPresent: List<String>.from(map['keywords_present'] ?? []),
        keywordsMissing: List<String>.from(map['keywords_missing'] ?? []),
        skillsAnalysis:
            SkillsAnalysisModel.fromJson(map['skills_analysis'] ?? {}),
        experienceGaps: List<String>.from(map['experience_gaps'] ?? []),
        coverLetter: map['cover_letter'] ?? '',
        linkedinSummary: map['linkedin_summary'] ?? '',
        elevatorPitch: map['elevator_pitch'] ?? '',
        interviewPrep: List<String>.from(map['interview_prep'] ?? []),
        quickWins: List<String>.from(map['quick_wins'] ?? []),
        salaryRange: map['salary_range'] ?? '',
        careerLevel: map['career_level'] ?? '',
        analyzedAt:
            DateTime.tryParse(map['analyzed_at'] ?? '') ?? DateTime.now(),
        rawCvText: map['raw_cv_text'] ?? '',
        proposedChanges: (map['proposed_changes'] as List? ?? [])
            .map((p) => ProposedChangeModel.fromJson(p))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }
}
