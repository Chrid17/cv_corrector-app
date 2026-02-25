import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../domain/entities/cv_analysis.dart';

class OverviewTab extends StatefulWidget {
  final CvAnalysis result;
  const OverviewTab({super.key, required this.result});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  bool _downloadingCV = false;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAtsHero(result),
          const SizedBox(height: 20),

          _buildScoreGrid(result),
          const SizedBox(height: 20),

          // Download Corrected CV
          if (result.correctedCvText.isNotEmpty)
            _buildDownloadCvCard(result).animate().fadeIn(delay: 150.ms),
          if (result.correctedCvText.isNotEmpty) const SizedBox(height: 20),

          _buildCareerInfo(result),
          const SizedBox(height: 20),

          InfoCard(
            title: 'CV Assessment',
            accentColor: AppColors.primary,
            child: Text(result.overallSummary, style: AppTextStyles.bodyLarge),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),

          InfoCard(
            title: 'Strengths',
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

          InfoCard(
            title: 'Critical Issues',
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

          InfoCard(
            title: 'Quick Wins',
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

  Widget _buildDownloadCvCard(CvAnalysis result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), AppColors.surface],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.file_download_outlined, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Corrected CV Ready', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 2),
                    Text(
                      'All corrections and improvements have been applied',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  label: _downloadingCV ? 'Generating...' : 'Download Corrected CV (PDF)',
                  icon: Icons.picture_as_pdf_outlined,
                  isLoading: _downloadingCV,
                  onTap: _downloadingCV ? null : () => _downloadCorrectedCv(result),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showCorrectedCvPreview(context, result),
                child: Text(
                  'Preview corrected CV',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              CopyButton(text: result.correctedCvText),
            ],
          ),
        ],
      ),
    );
  }

  void _showCorrectedCvPreview(BuildContext context, CvAnalysis result) {
    final text = result.correctedCvText.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No corrected CV text available.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 700,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Corrected CV Preview', style: AppTextStyles.headingMedium),
                    ),
                    CopyButton(text: text),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(dialogCtx),
                      child: const Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SelectableText(
                      text,
                      style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadCorrectedCv(CvAnalysis result) async {
    setState(() => _downloadingCV = true);
    try {
      final bytes = await PdfGenerator.generateCorrectedCvPdfBytes(
        correctedCvText: result.correctedCvText,
        candidateName: result.candidateName,
      );
      final safeName = result.candidateName.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      final savedPath = await PdfGenerator.savePdf(bytes, '${safeName}_Corrected_CV.pdf');
      if (mounted && savedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved: $savedPath'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _downloadingCV = false);
    }
  }

  Widget _buildAtsHero(CvAnalysis result) {
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

  Widget _buildScoreGrid(CvAnalysis result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoreRing(score: result.impactScore, label: 'Impact'),
        ScoreRing(score: result.readabilityScore, label: 'Readability'),
        ScoreRing(score: result.completenessScore, label: 'Completeness'),
      ],
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildCareerInfo(CvAnalysis result) {
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
              Icon(Icons.work_outline, color: AppColors.accent, size: 16),
              const SizedBox(width: 6),
              Text('Career Level', style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(result.careerLevel, style: AppTextStyles.label.copyWith(color: AppColors.accent), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
