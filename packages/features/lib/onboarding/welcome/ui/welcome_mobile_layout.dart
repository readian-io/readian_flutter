import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readian_presentation/designsystem/components/buttons.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';

import '../welcome_view_model.dart';

class WelcomeMobileLayout extends ConsumerWidget {
  const WelcomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  SvgPicture.asset(
                    'assets/images/image_readian_logo_with_r.svg',
                    height: 36,
                  ),

                  const SizedBox(height: 40),

                  SvgPicture.asset(
                    'assets/images/image_bookmark_wide.svg',
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 80),

                  // Buttons Section
                  _buildButtonsSection(context, l10n),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (welcomeState.loading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        ReadianButton(
          text: l10n.login,
          onPressed: () {
            // Handle login
          },
          style: ReadianButtonStyle.primary,
        ),

        const SizedBox(height: 8),

        ReadianButton(
          text: l10n.createAccount,
          onPressed: () {
            // Handle register
          },
          style: ReadianButtonStyle.outlined,
        ),

        const SizedBox(height: 24),

        ReadianButton(
          onPressed: () {
            // Handle skip
          },
          text: l10n.continueWithoutAccount,
          style: ReadianButtonStyle.text,
        ),
      ],
    );
  }
}
