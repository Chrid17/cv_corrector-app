import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class CompanyResearchTab extends StatelessWidget {
  final CvAnalysis result;
  const CompanyResearchTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final research = result.companyResearch;

    if (research == null) {
      return const EmptyState(
        icon: Icons.business_outlined,
        title: 'No Company Intel Available',
        subtitle: 'Add a job description when analyzing to get company research and interview insights.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.2), AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business_rounded, color: AppColors.accentLight, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  research.companyName.isNotEmpty ? research.companyName : 'Company',
                  style: AppTextStyles.headingLarge,
                ),
                if (research.industry.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  TagChip(label: research.industry, color: AppColors.accent),
                ],
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 20),

          // Company Overview
          if (research.companyOverview.isNotEmpty)
            InfoCard(
              title: 'Company Overview',
              accentColor: AppColors.primary,
              child: Text(research.companyOverview, style: AppTextStyles.bodyLarge),
            ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),

          // Culture Insights
          if (research.cultureInsights.isNotEmpty)
            InfoCard(
              title: 'Culture Insights',
              accentColor: AppColors.success,
              child: Column(
                children: research.cultureInsights.map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.groups_outlined, color: AppColors.success, size: 16),
                      const SizedBox(width: 10),
                      Expanded(child: Text(insight, style: AppTextStyles.bodyLarge)),
                    ],
                  ),
                )).toList(),
              ),
            ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),

          // Company Values
          if (research.values.isNotEmpty)
            InfoCard(
              title: 'Company Values',
              accentColor: AppColors.accent,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: research.values.map((v) =>
                  TagChip(label: v, color: AppColors.accent, icon: Icons.star_outline),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),

          // Interview Focus Areas
          if (research.interviewFocusAreas.isNotEmpty)
            InfoCard(
              title: 'What They Look For in Interviews',
              accentColor: AppColors.warning,
              child: Column(
                children: research.interviewFocusAreas.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text('${e.key + 1}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warning, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                    ],
                  ),
                )).toList(),
              ),
            ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),

          // Talking Points
          if (research.talkingPoints.isNotEmpty)
            InfoCard(
              title: 'Impress Them With These Talking Points',
              accentColor: AppColors.gold,
              trailing: CopyButton(
                text: research.talkingPoints.map((t) => '• $t').join('\n'),
              ),
              child: Column(
                children: research.talkingPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, color: AppColors.gold, size: 16),
                      const SizedBox(width: 10),
                      Expanded(child: Text(point, style: AppTextStyles.bodyLarge)),
                    ],
                  ),
                )).toList(),
              ),
            ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
