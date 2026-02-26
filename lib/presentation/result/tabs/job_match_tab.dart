import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class JobMatchTab extends StatelessWidget {
  final CvAnalysis result;
  const JobMatchTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final match = result.jobMatchAnalysis;

    if (match == null) {
      return const EmptyState(
        icon: Icons.compare_arrows_rounded,
        title: 'No Job Description Provided',
        subtitle: 'Add a job description when analyzing to see how your CV matches the role requirements.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ResponsiveContent(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Score Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.scoreColor(match.score).withOpacity(0.2),
                  AppColors.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.scoreColor(match.score).withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Text('Job Match Score', style: AppTextStyles.label),
                const SizedBox(height: 8),
                ScoreRing(score: match.score, label: '', size: 120),
                const SizedBox(height: 8),
                Text(
                  match.score >= 80 ? 'Excellent Match!' :
                  match.score >= 60 ? 'Good Match' :
                  match.score >= 40 ? 'Needs Improvement' :
                  'Significant Gaps',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: AppColors.scoreColor(match.score),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _miniStat('Keyword\nAlignment', '${match.keywordAlignment}%',
                        AppColors.scoreColor(match.keywordAlignment)),
                    _miniStat('Requirements\nMatched',
                        '${match.matchingRequirements.length}',
                        AppColors.success),
                    _miniStat('Requirements\nMissing',
                        '${match.missingRequirements.length}',
                        AppColors.error),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
          const SizedBox(height: 20),

          // Matching Requirements
          if (match.matchingRequirements.isNotEmpty)
            InfoCard(
              title: 'Requirements You Match',
              accentColor: AppColors.success,
              child: Column(
                children: match.matchingRequirements.asMap().entries.map((e) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),

          // Missing Requirements
          if (match.missingRequirements.isNotEmpty)
            InfoCard(
              title: 'Missing Requirements',
              accentColor: AppColors.error,
              child: Column(
                children: match.missingRequirements.asMap().entries.map((e) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.cancel_outlined, color: AppColors.error, size: 16),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),

          // Tailored Suggestions
          if (match.tailoredSuggestions.isNotEmpty)
            InfoCard(
              title: 'How to Improve Your Match',
              accentColor: AppColors.primary,
              child: Column(
                children: match.tailoredSuggestions.asMap().entries.map((e) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text('${e.key + 1}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 40),
        ],
      )),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headingLarge.copyWith(color: color, fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
