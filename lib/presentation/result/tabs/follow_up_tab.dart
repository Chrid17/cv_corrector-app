import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class FollowUpTab extends StatelessWidget {
  final CvAnalysis result;
  const FollowUpTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Follow-up Email
          if (result.followUpEmail.isNotEmpty)
            InfoCard(
              title: 'Post-Interview Follow-Up Email',
              accentColor: AppColors.primary,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CopyButton(text: result.followUpEmail),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Clipboard.setData(ClipboardData(text: result.followUpEmail)),
                    child: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 18),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(result.followUpEmail, style: AppTextStyles.bodyLarge),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Send within 24 hours of your interview. Customize the specifics based on your actual conversation.',
                          style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(),
          const SizedBox(height: 20),

          // Networking Message
          if (result.networkingMessage.isNotEmpty)
            InfoCard(
              title: 'LinkedIn Cold Outreach Message',
              accentColor: const Color(0xFF0077B5),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CopyButton(text: result.networkingMessage),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Clipboard.setData(ClipboardData(text: result.networkingMessage)),
                    child: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 18),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(result.networkingMessage, style: AppTextStyles.bodyLarge),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF0077B5), size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Personalize this for each connection. Mention a shared interest, mutual connection, or something from their profile.',
                          style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 20),

          // Cover Letter Review (if available)
          if (result.hasCoverLetterReview) ...[
            _buildCoverLetterReviewSection(result.coverLetterReview!),
            const SizedBox(height: 20),
          ],

          // Tailored Cover Letter (if JD was provided)
          if (result.tailoredCoverLetter.isNotEmpty)
            InfoCard(
              title: 'Tailored Cover Letter (for this JD)',
              accentColor: AppColors.success,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CopyButton(text: result.tailoredCoverLetter),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Clipboard.setData(ClipboardData(text: result.tailoredCoverLetter)),
                    child: const Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 18),
                  ),
                ],
              ),
              child: Text(result.tailoredCoverLetter, style: AppTextStyles.bodyLarge),
            ).animate().fadeIn(delay: 300.ms),

          if (result.followUpEmail.isEmpty && result.networkingMessage.isEmpty && !result.hasCoverLetterReview)
            const EmptyState(
              icon: Icons.email_outlined,
              title: 'No Follow-Up Content',
              subtitle: 'Follow-up emails and networking messages will appear here after analysis.',
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCoverLetterReviewSection(CoverLetterReview review) {
    return Column(
      children: [
        // Score card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.scoreColor(review.score).withOpacity(0.15),
                AppColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.scoreColor(review.score).withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text('Your Cover Letter Score', style: AppTextStyles.label),
              const SizedBox(height: 8),
              ScoreRing(score: review.score, label: review.verdict, size: 100),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),

        // Strengths
        if (review.strengths.isNotEmpty)
          InfoCard(
            title: 'Cover Letter Strengths',
            accentColor: AppColors.success,
            child: Column(
              children: review.strengths.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s, style: AppTextStyles.bodyLarge)),
                  ],
                ),
              )).toList(),
            ),
          ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 16),

        // Issues
        if (review.issues.isNotEmpty)
          InfoCard(
            title: 'Issues to Fix',
            accentColor: AppColors.error,
            child: Column(
              children: review.issues.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s, style: AppTextStyles.bodyLarge)),
                  ],
                ),
              )).toList(),
            ),
          ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 16),

        // Corrected Version
        if (review.correctedVersion.isNotEmpty)
          InfoCard(
            title: 'Improved Cover Letter',
            accentColor: AppColors.primary,
            trailing: CopyButton(text: review.correctedVersion),
            child: Text(review.correctedVersion, style: AppTextStyles.bodyLarge),
          ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 16),

        // Suggestions
        if (review.suggestions.isNotEmpty)
          InfoCard(
            title: 'Improvement Suggestions',
            accentColor: AppColors.warning,
            child: Column(
              children: review.suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 16),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s, style: AppTextStyles.bodyLarge)),
                  ],
                ),
              )).toList(),
            ),
          ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
