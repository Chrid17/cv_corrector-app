import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class OverviewTab extends StatelessWidget {
  final CvAnalysis result;
  const OverviewTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ATS Score hero
          _buildAtsHero(),
          const SizedBox(height: 20),

          // Score grid
          _buildScoreGrid(),
          const SizedBox(height: 20),

          // Career info
          _buildCareerInfo(),
          const SizedBox(height: 20),

          // Overall summary
          InfoCard(
            title: 'CV Assessment',
            accentColor: AppColors.primary,
            child: Text(result.overallSummary, style: AppTextStyles.bodyLarge),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),

          // Strengths
          InfoCard(
            title: '✅ Strengths',
            accentColor: AppColors.success,
            child: Column(
              children: result.strengths.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: AppColors.success, size: 13),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                  ],
                ),
              )).toList(),
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),

          // Critical issues
          InfoCard(
            title: '⚠️ Critical Issues',
            accentColor: AppColors.error,
            child: Column(
              children: result.criticalIssues.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: AppColors.error, size: 13),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
                  ],
                ),
              )).toList(),
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),

          // Quick wins
          InfoCard(
            title: '⚡ Quick Wins',
            accentColor: AppColors.warning,
            child: Column(
              children: result.quickWins.asMap().entries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                  Text('${e.key + 1}', style: AppTextStyles.label.copyWith(color: AppColors.warning)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(e.value, style: AppTextStyles.bodyLarge)),
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

  Widget _buildAtsHero() {
    final color = AppColors.scoreColor(result.atsScore);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('ATS Compatibility Score', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: result.atsScore.toDouble()),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Text(
              '${v.toInt()}',
              style: AppTextStyles.headingLarge.copyWith(fontSize: 64, color: color),
            ),
          ),
          Text('/100', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Text(result.atsVerdict, style: AppTextStyles.headingMedium.copyWith(color: color)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildScoreGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoreRing(score: result.impactScore, label: 'Impact'),
        ScoreRing(score: result.readabilityScore, label: 'Readability'),
        ScoreRing(score: result.completenessScore, label: 'Completeness'),
      ],
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildCareerInfo() {
    return _infoTile(Icons.work_outline, 'Career Level', result.careerLevel, AppColors.accent);
  }

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.label.copyWith(color: color), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
