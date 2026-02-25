import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class KeywordsTab extends StatelessWidget {
  final CvAnalysis result;
  const KeywordsTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final present = result.keywordsPresent;
    final missing = result.keywordsMissing;
    final total = present.length + missing.length;
    final pct = total == 0 ? 0.0 : present.length / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keyword match rate
          InfoCard(
            title: 'Keyword Match Rate',
            accentColor: AppColors.primary,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${present.length} / $total',
                      style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary),
                    ),
                    Text(
                      '${(pct * 100).toInt()}%',
                      style: AppTextStyles.headingMedium.copyWith(color: AppColors.scoreColor((pct * 100).toInt())),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: pct),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(AppColors.scoreColor((pct * 100).toInt())),
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add missing keywords to improve ATS compatibility',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 20),

          // Present keywords
          InfoCard(
            title: '✅ Found in Your CV (${present.length})',
            accentColor: AppColors.success,
            child: present.isEmpty
                ? Text('No keywords detected', style: AppTextStyles.bodyMedium)
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: present.asMap().entries.map((e) => TagChip(
                      label: e.value,
                      color: AppColors.success,
                      icon: Icons.check_circle_outline,
                    ).animate().fadeIn(delay: (e.key * 40).ms)).toList(),
                  ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 16),

          // Missing keywords
          InfoCard(
            title: '❌ Missing Keywords (${missing.length})',
            accentColor: AppColors.error,
            trailing: missing.isNotEmpty
                ? CopyButton(text: missing.join(', '))
                : null,
            child: missing.isEmpty
                ? Text('Great! No critical keywords missing', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consider adding these keywords naturally throughout your CV:',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: missing.asMap().entries.map((e) => TagChip(
                          label: e.value,
                          color: AppColors.error,
                          icon: Icons.add_circle_outline,
                        ).animate().fadeIn(delay: (e.key * 40).ms)).toList(),
                      ),
                    ],
                  ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 20),

          // Tips
          InfoCard(
            title: '💡 Keyword Strategy Tips',
            accentColor: AppColors.warning,
            child: Column(
              children: [
                _tip('Mirror the job description language exactly in your CV.'),
                _tip('Include acronyms AND their full forms (e.g., "ML (Machine Learning)").'),
                _tip('Add keywords to your summary, skills section, AND work experience.'),
                _tip('Don\'t keyword-stuff — integrate them naturally into context.'),
                _tip('Check 5–10 job listings in your field and note recurring terms.'),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _tip(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
      ],
    ),
  );
}
