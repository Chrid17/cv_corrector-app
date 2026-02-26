import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/utils/pdf_generator.dart';
import '../../../domain/entities/cv_analysis.dart';

class CoverLetterTab extends StatefulWidget {
  final CvAnalysis result;
  const CoverLetterTab({super.key, required this.result});

  @override
  State<CoverLetterTab> createState() => _CoverLetterTabState();
}

class _CoverLetterTabState extends State<CoverLetterTab> {
  bool _downloadingCL = false;
  bool _downloadingTailored = false;
  bool _downloadingCorrected = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ResponsiveContent(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Letter Review (if user uploaded one)
          if (r.hasCoverLetterReview) ...[
            _buildCoverLetterReview(r.coverLetterReview!),
            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 20),
          ],

          // Tailored Cover Letter (if JD was provided)
          if (r.tailoredCoverLetter.isNotEmpty) ...[
            _buildCoverLetterCard(
              title: 'Tailored Cover Letter',
              subtitle: 'Written specifically for the job description you provided',
              accentColor: AppColors.success,
              icon: Icons.check_circle_outline,
              content: r.tailoredCoverLetter,
              candidateName: r.candidateName,
              isDownloading: _downloadingTailored,
              onDownload: () => _downloadCoverLetter(
                r.tailoredCoverLetter, r.candidateName, 'tailored',
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),
          ],

          // Generated Cover Letter
          _buildCoverLetterCard(
            title: 'Generated Cover Letter',
            subtitle: r.tailoredCoverLetter.isNotEmpty
                ? 'General cover letter based on your CV'
                : 'Professional cover letter based on your CV',
            accentColor: AppColors.primary,
            icon: Icons.description_outlined,
            content: r.coverLetter,
            candidateName: r.candidateName,
            isDownloading: _downloadingCL,
            onDownload: () => _downloadCoverLetter(
              r.coverLetter, r.candidateName, 'general',
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),

          // LinkedIn summary
          InfoCard(
            title: 'LinkedIn Summary',
            accentColor: const Color(0xFF0077B5),
            trailing: CopyButton(text: r.linkedinSummary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use this as your LinkedIn "About" section:',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(r.linkedinSummary, style: AppTextStyles.bodyLarge),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 20),

          // Elevator pitch
          InfoCard(
            title: '30-Second Elevator Pitch',
            accentColor: AppColors.accent,
            trailing: CopyButton(text: r.elevatorPitch),
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
                    '"${r.elevatorPitch}"',
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
            title: 'Cover Letter Tips',
            accentColor: AppColors.warning,
            child: Column(
              children: [
                _tip('Customize the opening paragraph for each company you apply to.'),
                _tip('Always address it to a specific person when possible.'),
                _tip('Keep it to one page — hiring managers spend ~30 seconds reading.'),
                _tip('Mirror keywords from the job description naturally.'),
                _tip('End with a clear call to action and your contact details.'),
                _tip('Use formal business letter format — it works internationally.'),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 40),
        ],
      )),
    );
  }

  Widget _buildCoverLetterCard({
    required String title,
    required String subtitle,
    required Color accentColor,
    required IconData icon,
    required String content,
    required String candidateName,
    required bool isDownloading,
    required VoidCallback onDownload,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(width: 3, height: 16, color: accentColor, margin: const EdgeInsets.only(right: 10)),
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.label),
                      Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
                CopyButton(text: content),
              ],
            ),
          ),

          // Cover letter content - formatted
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildFormattedLetter(content),
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    label: isDownloading ? 'Generating PDF...' : 'Download as PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    isLoading: isDownloading,
                    onTap: isDownloading ? null : onDownload,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        backgroundColor: AppColors.success,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.copy_outlined, color: AppColors.textSecondary, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedLetter(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 10));
        continue;
      }

      final isHeader = i < 5 && (line.contains('@') || line.contains('P.O.') ||
          line.contains('Box') || RegExp(r'^\+?\d').hasMatch(line) ||
          line.contains('|'));
      final isDate = RegExp(r'^\d{1,2}\s\w+\s\d{4}$').hasMatch(line);
      final isSubject = line.startsWith('Re:') || line.startsWith('RE:');
      final isDear = line.startsWith('Dear ');
      final isClosing = line.startsWith('Yours ');
      final isSignature = line.startsWith('Mr.') || line.startsWith('Ms.') ||
          line.startsWith('Mrs.') || line.startsWith('Cell:') ||
          line.startsWith('Tel:') || line.startsWith('Email:');

      TextStyle style;
      if (isSubject) {
        style = AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, decoration: TextDecoration.underline);
      } else if (isDear || isClosing) {
        style = AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600);
      } else if (isSignature) {
        style = AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600);
      } else if (isDate || isHeader) {
        style = AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary);
      } else {
        style = AppTextStyles.bodyLarge.copyWith(height: 1.6);
      }

      widgets.add(Text(line, style: style));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildCoverLetterReview(CoverLetterReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 12),
              ScoreRing(score: review.score, label: review.verdict, size: 100),
            ],
          ),
        ).animate().fadeIn(),
        const SizedBox(height: 16),

        // Strengths
        if (review.strengths.isNotEmpty)
          InfoCard(
            title: 'Strengths',
            accentColor: AppColors.success,
            child: Column(
              children: review.strengths.map((s) => _listItem(s, Icons.check_circle, AppColors.success)).toList(),
            ),
          ).animate().fadeIn(delay: 50.ms),
        const SizedBox(height: 12),

        // Issues
        if (review.issues.isNotEmpty)
          InfoCard(
            title: 'Issues to Fix',
            accentColor: AppColors.error,
            child: Column(
              children: review.issues.map((s) => _listItem(s, Icons.warning_amber_rounded, AppColors.error)).toList(),
            ),
          ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 12),

        // Corrected Version with download
        if (review.correctedVersion.isNotEmpty)
          _buildCoverLetterCard(
            title: 'Corrected Cover Letter',
            subtitle: 'Your cover letter with all issues fixed and improvements applied',
            accentColor: AppColors.primary,
            icon: Icons.auto_fix_high,
            content: review.correctedVersion,
            candidateName: widget.result.candidateName,
            isDownloading: _downloadingCorrected,
            onDownload: () => _downloadCoverLetter(
              review.correctedVersion, widget.result.candidateName, 'corrected',
            ),
          ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: 12),

        // Suggestions
        if (review.suggestions.isNotEmpty)
          InfoCard(
            title: 'Improvement Suggestions',
            accentColor: AppColors.warning,
            child: Column(
              children: review.suggestions.map((s) => _listItem(s, Icons.lightbulb_outline, AppColors.warning)).toList(),
            ),
          ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _listItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
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

  Future<void> _downloadCoverLetter(String content, String name, String type) async {
    setState(() {
      if (type == 'tailored') _downloadingTailored = true;
      else if (type == 'corrected') _downloadingCorrected = true;
      else _downloadingCL = true;
    });

    try {
      final bytes = await PdfGenerator.generateCoverLetterPdfBytes(
        coverLetterText: content,
        candidateName: name,
      );
      final safeName = name.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');
      final fileName = type == 'tailored'
          ? '${safeName}_Tailored_Cover_Letter.pdf'
          : type == 'corrected'
              ? '${safeName}_Corrected_Cover_Letter.pdf'
              : '${safeName}_Cover_Letter.pdf';

      final savedPath = await PdfGenerator.savePdf(bytes, fileName);
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
      if (mounted) {
        setState(() {
          _downloadingTailored = false;
          _downloadingCorrected = false;
          _downloadingCL = false;
        });
      }
    }
  }
}
