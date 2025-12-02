import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final Uri _privacyUri = Uri.parse(
    'https://sites.google.com/view/luckyroutineprivacy/',
  );

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final didLaunch = await launchUrl(
        _privacyUri,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch) {
        _showError(messenger);
      }
    } catch (_) {
      _showError(messenger);
    }
  }

  void _showError(ScaffoldMessengerState messenger) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open the privacy policy')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lucky Routine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Version 1.0.1',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 12),
                Text(
                  'Keep your family organized by planning tasks and randomly '
                  'assigning chores to everyone.',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Review how we collect, store, and process your data.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _openPrivacyPolicy(context),
                  icon: const Icon(Icons.privacy_tip_outlined),
                  label: const Text('Open privacy policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Questions or feedback? Reach us anytime at',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 8),
                SelectableText(
                  'Pak.nain55@gmail.com',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: AppColors.softGlow,
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
