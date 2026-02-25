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
  });
}
