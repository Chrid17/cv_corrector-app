import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../providers/cv_provider.dart';
import '../../core/widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _keyController;
  bool _obscure = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CvProvider>();
    _keyController = TextEditingController(text: provider.apiKey);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.headingLarge),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Key section
            InfoCard(
              title: '🔑 API Key (FREE)',
              accentColor: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your API key to enable CV analysis. Get a free key — no credit card needed!',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _keyController,
                    obscureText: _obscure,
                    style: AppTextStyles.mono,
                    decoration: InputDecoration(
                      hintText: 'gsk_...',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.textSecondary, size: 20),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          if (_keyController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                              onPressed: () {
                                _keyController.clear();
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                    ),
                    onChanged: (_) => setState(() => _saved = false),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          label: _saved ? 'Saved ✓' : 'Save API Key',
                          icon: _saved ? null : Icons.save_outlined,
                          onTap: () => _saveKey(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showHowToGetKey(context),
                    child: Row(
                      children: [
                        const Icon(Icons.help_outline, color: AppColors.primary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'How to get your API key?',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            // Security note
            InfoCard(
              title: '🔒 Privacy & Security',
              accentColor: AppColors.success,
              child: Column(
                children: [
                  _secItem('Your API key is stored only on your device.'),
                  _secItem('CV text is processed securely — never stored on any server.'),
                  _secItem('Analysis results are saved locally on your device only.'),
                  _secItem('We never collect personal data.'),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 20),

            // App info
            InfoCard(
              title: '📱 About CV Analyzer Pro',
              accentColor: AppColors.textSecondary,
              child: Column(
                children: [
                  _infoRow('Version', '2.0.0'),
                  _infoRow('Platform', 'Built with Flutter'),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _secItem(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.shield_outlined, color: AppColors.success, size: 15),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
      ],
    ),
  );

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.label.copyWith(color: AppColors.primary)),
      ],
    ),
  );

  Future<void> _saveKey(BuildContext context) async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key'), backgroundColor: AppColors.error),
      );
      return;
    }
    await context.read<CvProvider>().saveApiKey(key);
    setState(() => _saved = true);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved!'), backgroundColor: AppColors.success),
      );
    }
  }

  void _showHowToGetKey(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to get your API Key (FREE)', style: AppTextStyles.headingMedium),
            const SizedBox(height: 16),
            _step('1', 'Go to console.groq.com'),
            _step('2', 'Sign up with Google or GitHub (free)'),
            _step('3', 'Click "API Keys" in the left sidebar'),
            _step('4', 'Click "Create API Key"'),
            _step('5', 'Copy the key and paste it here'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_outlined, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text('The API is 100% free with generous rate limits. No credit card needed!', style: AppTextStyles.bodySmall.copyWith(color: AppColors.success))),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _step(String num, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(num, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
      ],
    ),
  );
}
