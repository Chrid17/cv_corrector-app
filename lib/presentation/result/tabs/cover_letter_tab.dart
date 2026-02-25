import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class CoverLetterTab extends StatelessWidget {
  final CvAnalysis result;
  const CoverLetterTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover letter
          InfoCard(
            title: '📄 Cover Letter',
            accentColor: AppColors.primary,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CopyButton(text: result.coverLetter),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Share.share(result.coverLetter),
                  child: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 18),
                ),
              ],
            ),
            child: Text(result.coverLetter, style: AppTextStyles.bodyLarge),
          ).animate().fadeIn(),
          const SizedBox(height: 20),

          // LinkedIn summary
          InfoCard(
            title: '🔗 LinkedIn Summary',
            accentColor: const Color(0xFF0077B5),
            trailing: CopyButton(text: result.linkedinSummary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use this as your LinkedIn "About" section:',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(result.linkedinSummary, style: AppTextStyles.bodyLarge),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 20),

          // Elevator pitch
          InfoCard(
            title: '🎤 30-Second Elevator Pitch',
            accentColor: AppColors.accent,
            trailing: CopyButton(text: result.elevatorPitch),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memorize this for networking events and interviews:',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Text(
                    '"${result.elevatorPitch}"',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 20),

          // Tips
          InfoCard(
            title: '💡 Cover Letter Tips',
            accentColor: AppColors.warning,
            child: Column(
              children: [
                _tip('Customize the opening paragraph for each company.'),
                _tip('Always address it to a specific person when possible.'),
                _tip('Keep it to one page — hiring managers spend ~30 seconds reading.'),
                _tip('Mirror keywords from the job description.'),
                _tip('End with a clear call to action and your contact info.'),
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
