import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class SkillsTab extends StatelessWidget {
  final CvAnalysis result;
  const SkillsTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final s = result.skillsAnalysis;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Technical skills
          InfoCard(
            title: '⚙️ Technical Skills (${s.technical.length})',
            accentColor: AppColors.primary,
            child: s.technical.isEmpty
                ? Text('No technical skills detected. Consider adding a skills section.', style: AppTextStyles.bodyMedium)
                : Wrap(
                    spacing: 8, runSpacing: 8,
                    children: s.technical.asMap().entries.map((e) =>
                      TagChip(label: e.value, color: AppColors.primary)
                          .animate().fadeIn(delay: (e.key * 40).ms)).toList(),
                  ),
          ).animate().fadeIn(),
          const SizedBox(height: 16),

          // Soft skills
          InfoCard(
            title: '🤝 Soft Skills (${s.soft.length})',
            accentColor: AppColors.accent,
            child: s.soft.isEmpty
                ? Text('No soft skills detected. Add leadership, communication, and teamwork examples.', style: AppTextStyles.bodyMedium)
                : Wrap(
                    spacing: 8, runSpacing: 8,
                    children: s.soft.asMap().entries.map((e) =>
                      TagChip(label: e.value, color: AppColors.accentLight)
                          .animate().fadeIn(delay: (e.key * 40).ms)).toList(),
                  ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 16),

          // Recommended to add
          InfoCard(
            title: '📌 Recommended to Add',
            accentColor: AppColors.warning,
            child: s.missingRecommended.isEmpty
                ? Text('Your skill set looks comprehensive!', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('These skills are commonly expected for ${result.jobTitle} roles:', style: AppTextStyles.bodySmall),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: s.missingRecommended.asMap().entries.map((e) =>
                          TagChip(label: e.value, color: AppColors.warning, icon: Icons.add)
                              .animate().fadeIn(delay: (e.key * 40).ms)).toList(),
                      ),
                    ],
                  ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),

          // Experience gaps
          if (result.experienceGaps.isNotEmpty)
            InfoCard(
              title: '🔍 Experience Observations',
              accentColor: AppColors.textSecondary,
              child: Column(
                children: result.experienceGaps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 16),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                    ],
                  ),
                )).toList(),
              ),
            ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
