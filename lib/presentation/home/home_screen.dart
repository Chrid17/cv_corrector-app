import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../providers/cv_provider.dart';
import '../../core/utils/pdf_utils.dart';
import '../../core/widgets/common_widgets.dart';
import '../result/result_screen.dart';
import '../history/history_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  final _tabs = const [
    _AnalyzeTab(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onLongPress: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('CV', style: AppTextStyles.headingLarge.copyWith(color: AppColors.background, fontSize: 14)),
              ),
              const SizedBox(width: 6),
              Text('Corrector', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
      body: _tabs[_selectedTab],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: _selectedTab,
          onDestinationSelected: (i) => setState(() => _selectedTab = i),
          indicatorColor: AppColors.primary.withOpacity(0.15),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.document_scanner_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.document_scanner, color: AppColors.primary),
              label: 'Analyze',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.history, color: AppColors.primary),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Analyze Tab ──────────────────────────────────────────────────────────────
class _AnalyzeTab extends StatelessWidget {
  const _AnalyzeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<CvProvider>(
      builder: (context, provider, _) {
        if (provider.state == AnalysisState.loading) {
          return _LoadingView(message: provider.loadingMessage);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header
              _buildHero(context),
              const SizedBox(height: 28),

              // Feature chips
              _buildFeatureRow(),
              const SizedBox(height: 28),

              // Upload area
              _buildUploadArea(context, provider),
              const SizedBox(height: 16),

              // OR divider + paste
              const SectionDivider(label: 'OR PASTE YOUR CV TEXT'),
              const SizedBox(height: 16),

              // Text input
              _buildTextInput(context, provider),
              const SizedBox(height: 24),

              // Error
              if (provider.state == AnalysisState.error)
                _buildError(provider.errorMessage),

              // Analyze button
              GradientButton(
                label: 'Analyze My CV',
                icon: Icons.search_rounded,
                onTap: provider.cvText.isNotEmpty ? () => _analyze(context, provider) : null,
                width: double.infinity,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Professional', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary))
            .animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 4),
        Text('CV Analyzer\n& Corrector', style: AppTextStyles.headingLarge.copyWith(fontSize: 40))
            .animate().fadeIn(delay: 100.ms, duration: 400.ms),
        const SizedBox(height: 10),
        Text(
          'Upload your CV and get instant professional corrections, ATS scores, keyword analysis, a cover letter, and interview prep.',
          style: AppTextStyles.bodyMedium,
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildFeatureRow() {
    final features = [
      (Icons.spellcheck_rounded, 'Grammar Fix'),
      (Icons.speed_rounded, 'ATS Score'),
      (Icons.key_rounded, 'Keywords'),
      (Icons.mail_outline_rounded, 'Cover Letter'),
      (Icons.psychology_outlined, 'Interview Prep'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: features.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TagChip(label: e.value.item2, icon: e.value.item1)
              .animate().fadeIn(delay: (e.key * 60).ms),
        )).toList(),
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context, CvProvider provider) {
    return GestureDetector(
      onTap: () => _pickFile(context, provider),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: provider.hasCvText && provider.fileName.isNotEmpty
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: provider.cvText.isNotEmpty
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: provider.hasCvText && provider.fileName.isNotEmpty
                    ? AppColors.primaryGradient
                    : null,
                color: provider.hasCvText && provider.fileName.isNotEmpty
                    ? null
                    : AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                provider.cvText.isNotEmpty
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                color: provider.cvText.isNotEmpty
                    ? AppColors.background
                    : AppColors.textSecondary,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Upload PDF or TXT',
              style: AppTextStyles.headingMedium.copyWith(
                color: provider.cvText.isNotEmpty ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              provider.fileName.isNotEmpty
                  ? 'Tap to change file'
                  : 'Tap to browse  •  PDF, TXT supported',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildTextInput(BuildContext context, CvProvider provider) {
    return TextField(
      maxLines: 8,
      style: AppTextStyles.bodyLarge.copyWith(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Paste your CV text here...\n\nExample:\nJohn Doe\nSoftware Engineer\n...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
        suffixIcon: provider.hasCvText
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                onPressed: () => provider.clearCvText(),
              )
            : null,
      ),
      onChanged: (v) => provider.setCvText(v),
      controller: TextEditingController(text: provider.cvText),
    );
  }

  Widget _buildError(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error))),
        ],
      ),
    );
  }

  Future<void> _pickFile(BuildContext context, CvProvider provider) async {
    try {
      final res = await PdfUtils.pickAndExtractText();
      if (res != null) {
        provider.setCvText(res.text, fileName: res.fileName);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _analyze(BuildContext context, CvProvider provider) async {
    await provider.analyzeCV();
    if (provider.state == AnalysisState.success && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: provider.currentResult!)),
      );
    }
  }
}

// ─── Loading View ─────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  final String message;
  const _LoadingView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
              ),
              child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 42),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 36),
            Text('Analyzing your CV', style: AppTextStyles.headingLarge),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                message,
                key: ValueKey(message),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            LinearProgressIndicator(
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.circular(4),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms),
            const SizedBox(height: 16),
            Text('This may take 20–40 seconds', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

extension on (IconData, String) {
  IconData get item1 => $1;
  String get item2 => $2;
}
