/// Pure domain entities — no JSON, no framework dependencies.

class SkillsAnalysis {
  final List<String> technical;
  final List<String> soft;
  final List<String> missingRecommended;

  const SkillsAnalysis({
    required this.technical,
    required this.soft,
    required this.missingRecommended,
  });
}

class CvCorrection {
  final String section;
  final String type;
  final String original;
  final String corrected;
  final String reason;
  final String priority;

  const CvCorrection({
    required this.section,
    required this.type,
    required this.original,
    required this.corrected,
    required this.reason,
    required this.priority,
  });
}

class ProposedChange {
  final String section;
  final String currentText;
  final String suggestedText;
  final String rationale;
  final String impact; // High, Medium, Low

  const ProposedChange({
    required this.section,
    required this.currentText,
    required this.suggestedText,
    required this.rationale,
    required this.impact,
  });
}

class JobMatchAnalysis {
  final int score;
  final List<String> matchingRequirements;
  final List<String> missingRequirements;
  final List<String> tailoredSuggestions;
  final int keywordAlignment;

  const JobMatchAnalysis({
    required this.score,
    required this.matchingRequirements,
    required this.missingRequirements,
    required this.tailoredSuggestions,
    required this.keywordAlignment,
  });
}

class CompanyResearch {
  final String companyName;
  final String industry;
  final String companyOverview;
  final List<String> cultureInsights;
  final List<String> values;
  final List<String> interviewFocusAreas;
  final List<String> talkingPoints;

  const CompanyResearch({
    required this.companyName,
    required this.industry,
    required this.companyOverview,
    required this.cultureInsights,
    required this.values,
    required this.interviewFocusAreas,
    required this.talkingPoints,
  });
}

class CoverLetterReview {
  final int score;
  final String verdict;
  final List<String> strengths;
  final List<String> issues;
  final String correctedVersion;
  final List<String> suggestions;

  const CoverLetterReview({
    required this.score,
    required this.verdict,
    required this.strengths,
    required this.issues,
    required this.correctedVersion,
    required this.suggestions,
  });
}

class LearningPathItem {
  final String skill;
  final String priority;
  final List<String> resources;
  final String timeframe;

  const LearningPathItem({
    required this.skill,
    required this.priority,
    required this.resources,
    required this.timeframe,
  });
}

class SalaryNegotiation {
  final String marketRange;
  final List<String> negotiationTips;
  final List<String> talkingPoints;

  const SalaryNegotiation({
    required this.marketRange,
    required this.negotiationTips,
    required this.talkingPoints,
  });
}

class InterviewQA {
  final String question;
  final String sampleAnswer;
  final String category;

  const InterviewQA({
    required this.question,
    required this.sampleAnswer,
    required this.category,
  });
}

class CvAnalysis {
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
  final List<CvCorrection> corrections;
  final List<String> keywordsPresent;
  final List<String> keywordsMissing;
  final SkillsAnalysis skillsAnalysis;
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
  final List<ProposedChange> proposedChanges;

  // New fields
  final String correctedCvText;
  final String? jobDescriptionText;
  final String? rawCoverLetterText;
  final JobMatchAnalysis? jobMatchAnalysis;
  final CompanyResearch? companyResearch;
  final CoverLetterReview? coverLetterReview;
  final String tailoredCoverLetter;
  final String followUpEmail;
  final String networkingMessage;
  final List<LearningPathItem> learningPath;
  final SalaryNegotiation? salaryNegotiation;
  final List<InterviewQA> interviewQA;

  const CvAnalysis({
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
    this.proposedChanges = const [],
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

  bool get hasJobDescription => jobDescriptionText != null && jobDescriptionText!.isNotEmpty;
  bool get hasCoverLetterReview => coverLetterReview != null;
  bool get hasJobMatch => jobMatchAnalysis != null;
  bool get hasCompanyResearch => companyResearch != null;
}
