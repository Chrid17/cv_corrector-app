import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
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
              Text('Analyzer Pro', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
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
class _AnalyzeTab extends StatefulWidget {
  const _AnalyzeTab();

  @override
  State<_AnalyzeTab> createState() => _AnalyzeTabState();
}

class _AnalyzeTabState extends State<_AnalyzeTab> {
  bool _showJdSection = false;
  bool _showCoverLetterSection = false;
  late TextEditingController _cvController;
  late TextEditingController _jdController;
  late TextEditingController _clController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CvProvider>();
    _cvController = TextEditingController(text: provider.cvText);
    _jdController = TextEditingController(text: provider.jobDescriptionText);
    _clController = TextEditingController(text: provider.coverLetterText);
  }

  @override
  void dispose() {
    _cvController.dispose();
    _jdController.dispose();
    _clController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CvProvider>(
      builder: (context, provider, _) {
        if (provider.state == AnalysisState.loading) {
          return _LoadingView(message: provider.loadingMessage);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(context),
              const SizedBox(height: 28),
              _buildFeatureRow(),
              const SizedBox(height: 28),

              // CV Upload
              _buildSectionHeader('1. Your CV / Resume', Icons.description_outlined, true),
              const SizedBox(height: 12),
              _buildUploadArea(context, provider),
              const SizedBox(height: 12),
              const SectionDivider(label: 'OR PASTE YOUR CV TEXT'),
              const SizedBox(height: 12),
              _buildCvTextInput(provider),
              const SizedBox(height: 24),

              // Job Description Section (Collapsible)
              _buildExpandableSection(
                title: '2. Job Description (Optional)',
                icon: Icons.work_outline_rounded,
                subtitle: 'Add a JD for tailored analysis & company insights',
                isExpanded: _showJdSection,
                hasContent: provider.hasJobDescription || provider.hasJdImage,
                onToggle: () => setState(() => _showJdSection = !_showJdSection),
                child: _buildJdSection(context, provider),
              ),
              const SizedBox(height: 16),

              // Cover Letter Section (Collapsible)
              _buildExpandableSection(
                title: '3. Cover Letter (Optional)',
                icon: Icons.mail_outline_rounded,
                subtitle: 'Upload your cover letter for review & correction',
                isExpanded: _showCoverLetterSection,
                hasContent: provider.hasCoverLetter,
                onToggle: () => setState(() => _showCoverLetterSection = !_showCoverLetterSection),
                child: _buildCoverLetterSection(context, provider),
              ),
              const SizedBox(height: 24),

              // Error
              if (provider.state == AnalysisState.error)
                _buildError(provider.errorMessage),

              // Analyze button
              GradientButton(
                label: provider.hasJobDescription
                    ? 'Analyze & Match CV'
                    : 'Analyze My CV',
                icon: Icons.search_rounded,
                onTap: provider.cvText.isNotEmpty ? () => _analyze(context, provider) : null,
                width: double.infinity,
              ),
              const SizedBox(height: 8),
              if (provider.hasJobDescription || provider.hasCoverLetter)
                Center(
                  child: Text(
                    '${provider.hasJobDescription ? "JD matching" : ""}${provider.hasJobDescription && provider.hasCoverLetter ? " + " : ""}${provider.hasCoverLetter ? "Cover letter review" : ""} enabled',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool alwaysVisible) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.headingSmall),
      ],
    ).animate().fadeIn();
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required String subtitle,
    required bool isExpanded,
    required bool hasContent,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasContent ? AppColors.primary.withOpacity(0.5) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasContent
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasContent ? Icons.check_circle_rounded : icon,
                      color: hasContent ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.label),
                        const SizedBox(height: 2),
                        Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildJdSection(BuildContext context, CvProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),

        // Image upload for JD
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickJdImage(context, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                  decoration: BoxDecoration(
                    color: provider.hasJdImage
                        ? AppColors.primary.withOpacity(0.05)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: provider.hasJdImage
                          ? AppColors.primary.withOpacity(0.5)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        provider.hasJdImage ? Icons.check_circle : Icons.image_outlined,
                        color: provider.hasJdImage ? AppColors.primary : AppColors.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.hasJdImage ? provider.jdImageName : 'Upload Screenshot',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: provider.hasJdImage ? AppColors.primary : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (provider.hasJdImage && !provider.hasJobDescription) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: 80,
                child: provider.isExtractingImage
                    ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                    : GradientButton(
                        label: 'Extract Text',
                        icon: Icons.text_snippet_outlined,
                        onTap: () => _extractJdText(context, provider),
                      ),
              ),
            ],
          ],
        ),

        if (provider.hasJdImage) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              provider.jdImageBytes!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],

        const SizedBox(height: 12),
        const SectionDivider(label: 'OR PASTE JOB DESCRIPTION'),
        const SizedBox(height: 12),

        TextField(
          maxLines: 6,
          controller: _jdController,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Paste the job description here...\n\nThis enables:\n• JD-CV matching score\n• Company insights\n• Tailored cover letter',
            hintStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            suffixIcon: provider.hasJobDescription
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      _jdController.clear();
                      provider.clearJobDescription();
                    },
                  )
                : null,
          ),
          onChanged: (v) => provider.setJobDescription(v),
        ),
      ],
    );
  }

  Widget _buildCoverLetterSection(BuildContext context, CvProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),

        // File upload for cover letter
        GestureDetector(
          onTap: () => _pickCoverLetter(context, provider),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: provider.hasCoverLetter && provider.coverLetterFileName.isNotEmpty
                  ? AppColors.primary.withOpacity(0.05)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: provider.hasCoverLetter
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  provider.hasCoverLetter ? Icons.check_circle : Icons.upload_file_rounded,
                  color: provider.hasCoverLetter ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  provider.coverLetterFileName.isNotEmpty
                      ? provider.coverLetterFileName
                      : 'Upload Cover Letter (PDF/TXT)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: provider.hasCoverLetter ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SectionDivider(label: 'OR PASTE COVER LETTER'),
        const SizedBox(height: 12),
        TextField(
          maxLines: 6,
          controller: _clController,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Paste your cover letter here for review...\n\nYou\'ll receive:\n• Score & corrections\n• Improved version\n• Specific suggestions',
            hintStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            suffixIcon: provider.hasCoverLetter
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      _clController.clear();
                      provider.clearCoverLetter();
                    },
                  )
                : null,
          ),
          onChanged: (v) => provider.setCoverLetterText(v),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analyze. Improve.\nGet Hired.', style: AppTextStyles.headingLarge.copyWith(fontSize: 36))
            .animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 10),
        Text(
          'Upload your CV, job description & cover letter — get ATS scores, tailored corrections, company intel, interview prep, and more.',
          style: AppTextStyles.bodyMedium,
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildFeatureRow() {
    final features = [
      (Icons.speed_rounded, 'ATS Score'),
      (Icons.compare_arrows_rounded, 'JD Match'),
      (Icons.business_outlined, 'Company Intel'),
      (Icons.mail_outline_rounded, 'Cover Letter'),
      (Icons.psychology_outlined, 'Mock Interview'),
      (Icons.school_outlined, 'Learning Path'),
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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
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
              padding: const EdgeInsets.all(16),
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
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              provider.fileName.isNotEmpty ? provider.fileName : 'Upload PDF or TXT',
              style: AppTextStyles.headingSmall.copyWith(
                color: provider.cvText.isNotEmpty ? AppColors.primary : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildCvTextInput(CvProvider provider) {
    return TextField(
      maxLines: 6,
      controller: _cvController,
      style: AppTextStyles.bodyLarge.copyWith(fontSize: 12),
      decoration: InputDecoration(
        hintText: 'Paste your CV text here...\n\nExample:\nJohn Doe\nSoftware Engineer\n...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        suffixIcon: provider.hasCvText
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                onPressed: () {
                  _cvController.clear();
                  provider.clearCvText();
                },
              )
            : null,
      ),
      onChanged: (v) => provider.setCvText(v),
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
        _cvController.text = res.text;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickJdImage(BuildContext context, CvProvider provider) async {
    try {
      final res = await PdfUtils.pickImage();
      if (res != null) {
        final mimeTypes = {
          'png': 'image/png',
          'jpg': 'image/jpeg',
          'jpeg': 'image/jpeg',
          'webp': 'image/webp',
          'bmp': 'image/bmp',
        };
        final mimeType = mimeTypes[res.extension] ?? 'image/jpeg';
        provider.setJdImage(res.bytes, res.fileName, mimeType);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _extractJdText(BuildContext context, CvProvider provider) async {
    try {
      await provider.extractTextFromJdImage();
      if (provider.hasJobDescription) {
        _jdController.text = provider.jobDescriptionText;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Text extracted from image successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickCoverLetter(BuildContext context, CvProvider provider) async {
    try {
      final res = await PdfUtils.pickAndExtractText();
      if (res != null) {
        provider.setCoverLetterText(res.text, fileName: res.fileName);
        _clController.text = res.text;
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
            Text('Analyzing your documents', style: AppTextStyles.headingMedium),
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
            Text('This may take 30–60 seconds', style: AppTextStyles.bodySmall),
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
