import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/cv_analysis.dart';

class CorrectionsTab extends StatefulWidget {
  final CvAnalysis result;
  const CorrectionsTab({super.key, required this.result});

  @override
  State<CorrectionsTab> createState() => _CorrectionsTabState();
}

class _CorrectionsTabState extends State<CorrectionsTab> {
  String _filter = 'All';

  List<String> get _types => [
    'All',
    ...widget.result.corrections.map((c) => c.type).toSet().toList()..sort(),
  ];

  List<CvCorrection> get _filtered => _filter == 'All'
      ? widget.result.corrections
      : widget.result.corrections.where((c) => c.type == _filter).toList();

  Color _typeColor(String type) {
    switch (type) {
      case 'Grammar': return const Color(0xFFa78bfa);
      case 'Weak Language': return AppColors.warning;
      case 'Missing Info': return AppColors.error;
      case 'Structure': return const Color(0xFF3b82f6);
      case 'Formatting': return const Color(0xFFec4899);
      case 'Quantification': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter row
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _types.map((t) {
                final selected = _filter == t;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        t,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: selected ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Count
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            children: [
              Text(
                '${_filtered.length} correction${_filtered.length != 1 ? 's' : ''}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: _filtered.isEmpty
              ? const Center(child: Text('No corrections in this category'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _CorrectionCard(
                    correction: _filtered[i],
                    index: i,
                    typeColor: _typeColor(_filtered[i].type),
                  ),
                ),
        ),
      ],
    );
  }
}

class _CorrectionCard extends StatefulWidget {
  final CvCorrection correction;
  final int index;
  final Color typeColor;

  const _CorrectionCard({required this.correction, required this.index, required this.typeColor});

  @override
  State<_CorrectionCard> createState() => _CorrectionCardState();
}

class _CorrectionCardState extends State<_CorrectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.correction;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _expanded ? widget.typeColor.withOpacity(0.4) : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: widget.typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(color: widget.typeColor, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.section, style: AppTextStyles.label),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            TagChip(label: c.type, color: widget.typeColor),
                            const SizedBox(width: 6),
                            PriorityBadge(priority: c.priority),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary, size: 20,
                  ),
                ],
              ),
            ),

            // Expanded content
            if (_expanded) ...[
              const Divider(color: AppColors.border, height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Original
                    _label('BEFORE', AppColors.error),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.error.withOpacity(0.2)),
                      ),
                      child: Text(c.original, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary)),
                    ),
                    const SizedBox(height: 12),

                    // Corrected
                    _label('AFTER', AppColors.success),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.success.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(c.corrected, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.success))),
                          CopyButton(text: c.corrected),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reason
                    _label('WHY THIS MATTERS', AppColors.textSecondary),
                    const SizedBox(height: 6),
                    Text(c.reason, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(delay: (widget.index * 50).ms).slideY(begin: 0.05, end: 0),
    );
  }

  Widget _label(String text, Color color) => Text(
    text,
    style: AppTextStyles.bodySmall.copyWith(color: color),
  );
}
