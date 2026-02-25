import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class LearningPathTab extends StatelessWidget {
  final CvAnalysis result;
  const LearningPathTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.2), AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.route_outlined, color: AppColors.primary, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skills Roadmap', style: AppTextStyles.headingMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Personalized learning path to fill your skills gaps and accelerate your career.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 20),

          // Learning Path Items
          if (result.learningPath.isNotEmpty)
            ...result.learningPath.asMap().entries.map((e) =>
              _LearningPathCard(item: e.value, index: e.key)
                  .animate().fadeIn(delay: (e.key * 100).ms).slideY(begin: 0.05, end: 0),
            ),

          if (result.learningPath.isEmpty)
            const EmptyState(
              icon: Icons.school_outlined,
              title: 'No Learning Path Available',
              subtitle: 'Courses and skills to learn will appear here based on your CV analysis.',
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LearningPathCard extends StatelessWidget {
  final LearningPathItem item;
  final int index;
  const _LearningPathCard({required this.item, required this.index});

  Color get _priorityColor {
    switch (item.priority.toLowerCase()) {
      case 'high': return AppColors.error;
      case 'medium': return AppColors.warning;
      default: return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InfoCard(
        title: item.skill,
        accentColor: _priorityColor,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PriorityBadge(priority: item.priority),
            if (item.timeframe.isNotEmpty) ...[
              const SizedBox(width: 8),
              TagChip(
                label: item.timeframe,
                color: AppColors.textSecondary,
                icon: Icons.schedule,
              ),
            ],
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommended Resources:', style: AppTextStyles.label),
            const SizedBox(height: 8),
            ...item.resources.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined, color: _priorityColor, size: 14),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.value, style: AppTextStyles.bodyMedium)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
