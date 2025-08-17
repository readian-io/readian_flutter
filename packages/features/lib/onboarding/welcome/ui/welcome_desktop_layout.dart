import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readian_presentation/designsystem/components/buttons.dart';
import 'package:readian_presentation/navigation/navigation_providers.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';

import '../welcome_view_model.dart';

/// Desktop-specific layout for welcome screen
/// Features: Side-by-side layout with illustration on left, content on right
class WelcomeDesktopLayout extends ConsumerWidget {
  const WelcomeDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: _LeftPanel()),
              Expanded(flex: 2, child: _RightPanel(l10n: l10n)),
            ],
          ),

          if (welcomeState.loading)
            Container(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: SvgPicture.asset(
            'assets/images/image_bookmark_wide.svg',
            width: 400,
            height: 500,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _RightPanel extends ConsumerWidget {
  const _RightPanel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 80),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome title
                Text(
                  l10n.welcomeTo,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                // App name/brand
                Text(
                  l10n.appName,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  l10n.appDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.6,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 48),

                // Action buttons
                _buildActionButtons(context, ref, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/image_readian_logo_with_r.svg',
          height: 36,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReadianButton(
          text: l10n.login,
          onPressed: () {
            ref.navigation(context).navigateToLogin();
          },
          style: ReadianButtonStyle.primary,
        ),

        const SizedBox(height: 16),

        ReadianButton(
          text: l10n.createAccount,
          onPressed: () {
            // Handle register
          },
          style: ReadianButtonStyle.outlined,
        ),

        const SizedBox(height: 32),

        Center(
          child: ReadianButton(
            text: l10n.continueWithoutAccount,
            onPressed: () {
              // Handle skip
            },
            style: ReadianButtonStyle.tertiary,
          ),
        ),
      ],
    );
  }
}
