import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';

import '../welcome_view_model.dart';
import '../../../presentation/designsystem/components/app_text_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Column(
            children: [
              TopContent(l10n, welcomeViewModel),

              const SizedBox(height: 16),

              MainImageContent(),

              const SizedBox(height: 16),

              FetureDescriptionContent(l10n, theme),

              // Bottom section with pagination and next button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pagination dots
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  // Next button
                  ReadianButton(
                    text: l10n.next,
                    onPressed: welcomeViewModel.navigateToRegister,
                    style: ReadianButtonStyle.outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded FetureDescriptionContent(AppLocalizations l10n, ThemeData theme) {
    return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main heading
                  Text(
                    l10n.spotlightTitle,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    l10n.spotlightDescription,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            );
  }

  Align MainImageContent() {
    return Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                'assets/images/image_lamp.svg',
                width: 88,
                height: 138,
              ),
            );
  }

  Row TopContent(AppLocalizations l10n, WelcomeViewModel welcomeViewModel) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                SvgPicture.asset(
                  'assets/images/image_readian.svg',
                  height: 22,
                ),

                ReadianButton(
                  text: l10n.loginOrRegister,
                  onPressed: welcomeViewModel.navigateToLogin,
                  style: ReadianButtonStyle.small,
                ),

              ],
            );
  }
}
