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

class JobMatchAnalysisModel {
  final int score;
  final List<String> matchingRequirements;
  final List<String> missingRequirements;
  final List<String> tailoredSuggestions;
  final int keywordAlignment;

  JobMatchAnalysisModel({
    required this.score,
    required this.matchingRequirements,
    required this.missingRequirements,
    required this.tailoredSuggestions,
    required this.keywordAlignment,
  });

  factory JobMatchAnalysisModel.fromJson(Map<String, dynamic> json) =>
      JobMatchAnalysisModel(
        score: (json['score'] ?? 0).toInt(),
        matchingRequirements: List<String>.from(json['matching_requirements'] ?? []),
        missingRequirements: List<String>.from(json['missing_requirements'] ?? []),
        tailoredSuggestions: List<String>.from(json['tailored_suggestions'] ?? []),
        keywordAlignment: (json['keyword_alignment'] ?? 0).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'matching_requirements': matchingRequirements,
        'missing_requirements': missingRequirements,
        'tailored_suggestions': tailoredSuggestions,
        'keyword_alignment': keywordAlignment,
      };

  domain.JobMatchAnalysis toEntity() => domain.JobMatchAnalysis(
        score: score,
        matchingRequirements: matchingRequirements,
        missingRequirements: missingRequirements,
        tailoredSuggestions: tailoredSuggestions,
        keywordAlignment: keywordAlignment,
      );

  factory JobMatchAnalysisModel.fromEntity(domain.JobMatchAnalysis entity) =>
      JobMatchAnalysisModel(
        score: entity.score,
        matchingRequirements: entity.matchingRequirements,
        missingRequirements: entity.missingRequirements,
        tailoredSuggestions: entity.tailoredSuggestions,
        keywordAlignment: entity.keywordAlignment,
      );
}

class CompanyResearchModel {
  final String companyName;
  final String industry;
  final String companyOverview;
  final List<String> cultureInsights;
  final List<String> values;
  final List<String> interviewFocusAreas;
  final List<String> talkingPoints;

  CompanyResearchModel({
    required this.companyName,
    required this.industry,
    required this.companyOverview,
    required this.cultureInsights,
    required this.values,
    required this.interviewFocusAreas,
    required this.talkingPoints,
  });

  factory CompanyResearchModel.fromJson(Map<String, dynamic> json) =>
      CompanyResearchModel(
        companyName: json['company_name'] ?? '',
        industry: json['industry'] ?? '',
        companyOverview: json['company_overview'] ?? '',
        cultureInsights: List<String>.from(json['culture_insights'] ?? []),
        values: List<String>.from(json['values'] ?? []),
        interviewFocusAreas: List<String>.from(json['interview_focus_areas'] ?? []),
        talkingPoints: List<String>.from(json['talking_points'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'company_name': companyName,
        'industry': industry,
        'company_overview': companyOverview,
        'culture_insights': cultureInsights,
        'values': values,
        'interview_focus_areas': interviewFocusAreas,
        'talking_points': talkingPoints,
      };

  domain.CompanyResearch toEntity() => domain.CompanyResearch(
        companyName: companyName,
        industry: industry,
        companyOverview: companyOverview,
        cultureInsights: cultureInsights,
        values: values,
        interviewFocusAreas: interviewFocusAreas,
        talkingPoints: talkingPoints,
      );

  factory CompanyResearchModel.fromEntity(domain.CompanyResearch entity) =>
      CompanyResearchModel(
        companyName: entity.companyName,
        industry: entity.industry,
        companyOverview: entity.companyOverview,
        cultureInsights: entity.cultureInsights,
        values: entity.values,
        interviewFocusAreas: entity.interviewFocusAreas,
        talkingPoints: entity.talkingPoints,
      );
}

class CoverLetterReviewModel {
  final int score;
  final String verdict;
  final List<String> strengths;
  final List<String> issues;
  final String correctedVersion;
  final List<String> suggestions;

  CoverLetterReviewModel({
    required this.score,
    required this.verdict,
    required this.strengths,
    required this.issues,
    required this.correctedVersion,
    required this.suggestions,
  });

  factory CoverLetterReviewModel.fromJson(Map<String, dynamic> json) =>
      CoverLetterReviewModel(
        score: (json['score'] ?? 0).toInt(),
        verdict: json['verdict'] ?? 'Fair',
        strengths: List<String>.from(json['strengths'] ?? []),
        issues: List<String>.from(json['issues'] ?? []),
        correctedVersion: json['corrected_version'] ?? '',
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'score': score,
        'verdict': verdict,
        'strengths': strengths,
        'issues': issues,
        'corrected_version': correctedVersion,
        'suggestions': suggestions,
      };

  domain.CoverLetterReview toEntity() => domain.CoverLetterReview(
        score: score,
        verdict: verdict,
        strengths: strengths,
        issues: issues,
        correctedVersion: correctedVersion,
        suggestions: suggestions,
      );

  factory CoverLetterReviewModel.fromEntity(domain.CoverLetterReview entity) =>
      CoverLetterReviewModel(
        score: entity.score,
        verdict: entity.verdict,
        strengths: entity.strengths,
        issues: entity.issues,
        correctedVersion: entity.correctedVersion,
        suggestions: entity.suggestions,
      );
}

class LearningPathItemModel {
  final String skill;
  final String priority;
  final List<String> resources;
  final String timeframe;

  LearningPathItemModel({
    required this.skill,
    required this.priority,
    required this.resources,
    required this.timeframe,
  });

  factory LearningPathItemModel.fromJson(Map<String, dynamic> json) =>
      LearningPathItemModel(
        skill: json['skill'] ?? '',
        priority: json['priority'] ?? 'Medium',
        resources: List<String>.from(json['resources'] ?? []),
        timeframe: json['timeframe'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'skill': skill,
        'priority': priority,
        'resources': resources,
        'timeframe': timeframe,
      };

  domain.LearningPathItem toEntity() => domain.LearningPathItem(
        skill: skill,
        priority: priority,
        resources: resources,
        timeframe: timeframe,
      );

  factory LearningPathItemModel.fromEntity(domain.LearningPathItem entity) =>
      LearningPathItemModel(
        skill: entity.skill,
        priority: entity.priority,
        resources: entity.resources,
        timeframe: entity.timeframe,
      );
}

class SalaryNegotiationModel {
  final String marketRange;
  final List<String> negotiationTips;
  final List<String> talkingPoints;

  SalaryNegotiationModel({
    required this.marketRange,
    required this.negotiationTips,
    required this.talkingPoints,
  });

  factory SalaryNegotiationModel.fromJson(Map<String, dynamic> json) =>
      SalaryNegotiationModel(
        marketRange: json['market_range'] ?? '',
        negotiationTips: List<String>.from(json['negotiation_tips'] ?? []),
        talkingPoints: List<String>.from(json['talking_points'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'market_range': marketRange,
        'negotiation_tips': negotiationTips,
        'talking_points': talkingPoints,
      };

  domain.SalaryNegotiation toEntity() => domain.SalaryNegotiation(
        marketRange: marketRange,
        negotiationTips: negotiationTips,
        talkingPoints: talkingPoints,
      );

  factory SalaryNegotiationModel.fromEntity(domain.SalaryNegotiation entity) =>
      SalaryNegotiationModel(
        marketRange: entity.marketRange,
        negotiationTips: entity.negotiationTips,
        talkingPoints: entity.talkingPoints,
      );
}

class InterviewQAModel {
  final String question;
  final String sampleAnswer;
  final String category;

  InterviewQAModel({
    required this.question,
    required this.sampleAnswer,
    required this.category,
  });

  factory InterviewQAModel.fromJson(Map<String, dynamic> json) =>
      InterviewQAModel(
        question: json['question'] ?? '',
        sampleAnswer: json['sample_answer'] ?? '',
        category: json['category'] ?? 'General',
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'sample_answer': sampleAnswer,
        'category': category,
      };

  domain.InterviewQA toEntity() => domain.InterviewQA(
        question: question,
        sampleAnswer: sampleAnswer,
        category: category,
      );

  factory InterviewQAModel.fromEntity(domain.InterviewQA entity) =>
      InterviewQAModel(
        question: entity.question,
        sampleAnswer: entity.sampleAnswer,
        category: entity.category,
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

  // New fields
  final String correctedCvText;
  final String? jobDescriptionText;
  final String? rawCoverLetterText;
  final JobMatchAnalysisModel? jobMatchAnalysis;
  final CompanyResearchModel? companyResearch;
  final CoverLetterReviewModel? coverLetterReview;
  final String tailoredCoverLetter;
  final String followUpEmail;
  final String networkingMessage;
  final List<LearningPathItemModel> learningPath;
  final SalaryNegotiationModel? salaryNegotiation;
  final List<InterviewQAModel> interviewQA;

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
    this.correctedCvText = '',
    this.jobDescriptionText,
    this.rawCoverLetterText,
    this.jobMatchAnalysis,
    this.companyResearch,
    this.coverLetterReview,
    this.tailoredCoverLetter = '',
    this.followUpEmail = '',
    this.networkingMessage = '',
    this.learningPath = const [],
    this.salaryNegotiation,
    this.interviewQA = const [],
  });

  factory CvAnalysisModel.fromApiJson(
    Map<String, dynamic> json, {
    required String rawCvText,
    String? jobDescriptionText,
    String? rawCoverLetterText,
  }) {
    // Parse interview_qa - can be list of strings or list of objects
    List<InterviewQAModel> interviewQA = [];
    final qaRaw = json['interview_qa'];
    if (qaRaw is List) {
      interviewQA = qaRaw.map((item) {
        if (item is Map<String, dynamic>) {
          return InterviewQAModel.fromJson(item);
        }
        return InterviewQAModel(
          question: item.toString(),
          sampleAnswer: '',
          category: 'General',
        );
      }).toList();
    }

    return CvAnalysisModel(
      id: json['id'] ?? '',
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
      correctedCvText: json['corrected_cv_text'] ?? '',
      jobDescriptionText: jobDescriptionText,
      rawCoverLetterText: rawCoverLetterText,
      jobMatchAnalysis: json['job_match_analysis'] != null
          ? JobMatchAnalysisModel.fromJson(json['job_match_analysis'])
          : null,
      companyResearch: json['company_research'] != null
          ? CompanyResearchModel.fromJson(json['company_research'])
          : null,
      coverLetterReview: json['cover_letter_review'] != null
          ? CoverLetterReviewModel.fromJson(json['cover_letter_review'])
          : null,
      tailoredCoverLetter: json['tailored_cover_letter'] ?? '',
      followUpEmail: json['follow_up_email'] ?? '',
      networkingMessage: json['networking_message'] ?? '',
      learningPath: (json['learning_path'] as List? ?? [])
          .map((l) => LearningPathItemModel.fromJson(l))
          .toList(),
      salaryNegotiation: json['salary_negotiation'] != null
          ? SalaryNegotiationModel.fromJson(json['salary_negotiation'])
          : null,
      interviewQA: interviewQA,
    );
  }

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
        correctedCvText: entity.correctedCvText,
        jobDescriptionText: entity.jobDescriptionText,
        rawCoverLetterText: entity.rawCoverLetterText,
        jobMatchAnalysis: entity.jobMatchAnalysis != null
            ? JobMatchAnalysisModel.fromEntity(entity.jobMatchAnalysis!)
            : null,
        companyResearch: entity.companyResearch != null
            ? CompanyResearchModel.fromEntity(entity.companyResearch!)
            : null,
        coverLetterReview: entity.coverLetterReview != null
            ? CoverLetterReviewModel.fromEntity(entity.coverLetterReview!)
            : null,
        tailoredCoverLetter: entity.tailoredCoverLetter,
        followUpEmail: entity.followUpEmail,
        networkingMessage: entity.networkingMessage,
        learningPath: entity.learningPath
            .map((l) => LearningPathItemModel.fromEntity(l))
            .toList(),
        salaryNegotiation: entity.salaryNegotiation != null
            ? SalaryNegotiationModel.fromEntity(entity.salaryNegotiation!)
            : null,
        interviewQA: entity.interviewQA
            .map((q) => InterviewQAModel.fromEntity(q))
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
        correctedCvText: correctedCvText,
        jobDescriptionText: jobDescriptionText,
        rawCoverLetterText: rawCoverLetterText,
        jobMatchAnalysis: jobMatchAnalysis?.toEntity(),
        companyResearch: companyResearch?.toEntity(),
        coverLetterReview: coverLetterReview?.toEntity(),
        tailoredCoverLetter: tailoredCoverLetter,
        followUpEmail: followUpEmail,
        networkingMessage: networkingMessage,
        learningPath: learningPath.map((l) => l.toEntity()).toList(),
        salaryNegotiation: salaryNegotiation?.toEntity(),
        interviewQA: interviewQA.map((q) => q.toEntity()).toList(),
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
        'corrected_cv_text': correctedCvText,
        'job_description_text': jobDescriptionText,
        'raw_cover_letter_text': rawCoverLetterText,
        'job_match_analysis': jobMatchAnalysis?.toJson(),
        'company_research': companyResearch?.toJson(),
        'cover_letter_review': coverLetterReview?.toJson(),
        'tailored_cover_letter': tailoredCoverLetter,
        'follow_up_email': followUpEmail,
        'networking_message': networkingMessage,
        'learning_path': learningPath.map((l) => l.toJson()).toList(),
        'salary_negotiation': salaryNegotiation?.toJson(),
        'interview_qa': interviewQA.map((q) => q.toJson()).toList(),
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
        correctedCvText: map['corrected_cv_text'] ?? '',
        jobDescriptionText: map['job_description_text'],
        rawCoverLetterText: map['raw_cover_letter_text'],
        jobMatchAnalysis: map['job_match_analysis'] != null
            ? JobMatchAnalysisModel.fromJson(map['job_match_analysis'])
            : null,
        companyResearch: map['company_research'] != null
            ? CompanyResearchModel.fromJson(map['company_research'])
            : null,
        coverLetterReview: map['cover_letter_review'] != null
            ? CoverLetterReviewModel.fromJson(map['cover_letter_review'])
            : null,
        tailoredCoverLetter: map['tailored_cover_letter'] ?? '',
        followUpEmail: map['follow_up_email'] ?? '',
        networkingMessage: map['networking_message'] ?? '',
        learningPath: (map['learning_path'] as List? ?? [])
            .map((l) => LearningPathItemModel.fromJson(l))
            .toList(),
        salaryNegotiation: map['salary_negotiation'] != null
            ? SalaryNegotiationModel.fromJson(map['salary_negotiation'])
            : null,
        interviewQA: (map['interview_qa'] as List? ?? [])
            .map((q) => InterviewQAModel.fromJson(q is Map<String, dynamic> ? q : {'question': q.toString()}))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }
}
