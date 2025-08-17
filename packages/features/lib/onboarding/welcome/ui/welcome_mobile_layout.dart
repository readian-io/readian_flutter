import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';
import 'package:readian_presentation/designsystem/components/buttons.dart';
import 'package:readian_presentation/navigation/navigation_providers.dart';

import '../welcome_view_model.dart';

class WelcomeMobileLayout extends ConsumerWidget {
  const WelcomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final l10n = AppLocalizations.of(context);

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
                  _buildButtonsSection(context, ref, l10n),

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

  Widget _buildButtonsSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        ReadianButton(
          text: l10n.login,
          onPressed: () {
            ref.navigation(context).navigateToLogin();
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

        const SizedBox(height: 16),

        ReadianButton(
          onPressed: () {
            // Handle skip
          },
          text: l10n.continueWithoutAccount,
          style: ReadianButtonStyle.tertiary,
        ),
      ],
    );
  }
}
