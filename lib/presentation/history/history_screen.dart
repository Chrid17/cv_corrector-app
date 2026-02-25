import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../providers/cv_provider.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/entities/cv_analysis.dart';
import '../result/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CvProvider>(
      builder: (context, provider, _) {
        final history = provider.history;
        if (history.isEmpty) {
          return EmptyState(
            icon: Icons.history_outlined,
            title: 'No analyses yet',
            subtitle: 'Your CV analysis history will appear here',
          );
        }
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text('${history.length} analysis${history.length != 1 ? 'es' : ''}', style: AppTextStyles.bodyMedium),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _confirmClear(context, provider),
                    child: Text('Clear all', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _HistoryCard(
                  result: history[i],
                  onTap: () {
                    provider.viewResultFromHistory(history[i]);
                    Navigator.push(ctx, MaterialPageRoute(builder: (_) => ResultScreen(result: history[i])));
                  },
                  onDelete: () => _confirmDelete(ctx, provider, history[i]),
                  onRedo: () {
                    // Navigate to Analyze tab and show a message
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Upload or paste your CV text and tap "Analyze My CV" to re-analyze.'),
                        backgroundColor: AppColors.primary,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ).animate().fadeIn(delay: (i * 60).ms),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, CvProvider provider, CvAnalysis item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete Analysis', style: AppTextStyles.headingMedium),
        content: Text('Delete the analysis for "${item.candidateName}"?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true) provider.deleteHistory(item.id);
  }

  Future<void> _confirmClear(BuildContext context, CvProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Clear History', style: AppTextStyles.headingMedium),
        content: Text('Are you sure you want to delete all CV analyses?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete All', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true) provider.clearHistory();
  }
}

class _HistoryCard extends StatelessWidget {
  final CvAnalysis result;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRedo;

  const _HistoryCard({
    required this.result,
    required this.onTap,
    required this.onDelete,
    required this.onRedo,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.scoreColor(result.atsScore);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Score circle
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.4), width: 2),
              ),
              child: Center(
                child: Text(
                  '${result.atsScore}',
                  style: AppTextStyles.headingMedium.copyWith(color: color),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.candidateName, style: AppTextStyles.label),
                  const SizedBox(height: 3),
                  Text(result.jobTitle, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      TagChip(label: result.careerLevel, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM d, yyyy').format(result.analyzedAt),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Popup menu with actions
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
              color: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    onTap();
                    break;
                  case 'redo':
                    onRedo();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text('View', style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'redo',
                  child: Row(
                    children: [
                      const Icon(Icons.refresh_rounded, size: 18, color: AppColors.accent),
                      const SizedBox(width: 10),
                      Text('Re-analyze', style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      const SizedBox(width: 10),
                      Text('Delete', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
