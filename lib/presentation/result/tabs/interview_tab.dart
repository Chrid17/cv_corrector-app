import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class InterviewTab extends StatelessWidget {
  final CvAnalysis result;
  const InterviewTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent.withOpacity(0.2), AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_outlined, color: AppColors.accentLight, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Interview Prep', style: AppTextStyles.headingMedium),
                      const SizedBox(height: 4),
                      Text(
                        'These questions are likely based on your CV and the role of ${result.jobTitle}.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 20),

          // Questions
          ...result.interviewPrep.asMap().entries.map((e) => _QuestionCard(
            number: e.key + 1,
            question: e.value,
          ).animate().fadeIn(delay: (e.key * 80).ms).slideY(begin: 0.05, end: 0)),

          const SizedBox(height: 20),

          // STAR method
          InfoCard(
            title: '⭐ The STAR Method',
            accentColor: AppColors.gold,
            child: Column(
              children: [
                _starItem('Situation', 'Set the scene. Describe the context and background.', AppColors.gold),
                _starItem('Task', 'Explain your responsibility or role in the situation.', AppColors.warning),
                _starItem('Action', 'Describe the specific steps YOU took.', AppColors.primary),
                _starItem('Result', 'Share the measurable outcome. Use numbers!', AppColors.success),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 20),

          // General tips
          InfoCard(
            title: '💡 Interview Tips',
            accentColor: AppColors.primary,
            child: Column(
              children: [
                _tip(Icons.timer_outlined, 'Research the company thoroughly before the interview.'),
                _tip(Icons.format_list_numbered, 'Prepare 3–5 examples using the STAR method.'),
                _tip(Icons.attach_money, 'Know your salary range and negotiate confidently.'),
                _tip(Icons.help_outline, 'Prepare thoughtful questions to ask the interviewer.'),
                _tip(Icons.check_circle_outline, 'Follow up with a thank-you email within 24 hours.'),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _starItem(String label, String desc, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(label[0], style: AppTextStyles.label.copyWith(color: color))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.label.copyWith(color: color)),
              Text(desc, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _tip(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
      ],
    ),
  );
}

class _QuestionCard extends StatefulWidget {
  final int number;
  final String question;
  const _QuestionCard({required this.number, required this.question});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _showAnswer ? AppColors.accent.withOpacity(0.4) : AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Q${widget.number}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentLight, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(widget.question, style: AppTextStyles.bodyLarge),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: GestureDetector(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  Text(
                    _showAnswer ? 'Hide tips ▲' : 'Show answer tips ▼',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentLight),
                  ),
                ],
              ),
            ),
          ),
          if (_showAnswer)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 How to approach this:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentLight)),
                  const SizedBox(height: 6),
                  Text(
                    'Use the STAR method. Prepare a specific example from your experience. Be concise (90 seconds max). Quantify your results whenever possible.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
