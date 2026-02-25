import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../providers/cv_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';

class ProposedChangesTab extends StatelessWidget {
  const ProposedChangesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CvProvider>();
    final result = provider.currentResult;

    if (result == null || result.proposedChanges.isEmpty) {
      return const EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'No proposed changes',
        subtitle: 'Your current formatting and content appear optimal for these sections.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: result.proposedChanges.length,
      itemBuilder: (context, index) {
        final change = result.proposedChanges[index];
        return InfoCard(
          title: change.section,
          accentColor: _getImpactColor(change.impact),
          trailing: PriorityBadge(priority: change.impact),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextSection('Current', change.currentText, isOriginal: true),
              const SizedBox(height: 12),
              _buildTextSection('Suggested', change.suggestedText, isOriginal: false),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      change.rationale,
                      style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Copy Suggested Text',
                icon: Icons.copy,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: change.suggestedText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextSection(String label, String text, {required bool isOriginal}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(
          color: isOriginal ? AppColors.textMuted : AppColors.primary,
        )),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isOriginal ? AppColors.border : AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isOriginal ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getImpactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'high': return AppColors.error;
      case 'medium': return AppColors.warning;
      case 'low': return AppColors.success;
      default: return AppColors.primary;
    }
  }
}
