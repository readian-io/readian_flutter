import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';
import 'package:readian_presentation/presentation.dart';

import '../state/tutorial_state.dart';
import '../tutorial_view_model.dart';

/// Desktop-specific layout for tutorial screen
/// Features: Side-by-side layout with image on left, content on right
class TutorialDesktopLayout extends ConsumerStatefulWidget {
  const TutorialDesktopLayout({super.key});

  @override
  ConsumerState<TutorialDesktopLayout> createState() =>
      _TutorialDesktopLayoutState();
}

class _TutorialDesktopLayoutState extends ConsumerState<TutorialDesktopLayout> {
  late final TutorialViewModel tutorialViewModel;
  StreamSubscription<NavigationSideEffect>? _navigationSubscription;

  @override
  void initState() {
    super.initState();
    tutorialViewModel = ref.read(tutorialViewModelProvider.notifier);
    _navigationSubscription = tutorialViewModel.navigationEvents.listen((
      event,
    ) {
      event.when(
        navigateToRegister: () => ref.navigation(context).navigateToRegister(),
      );
    });
  }

  @override
  void dispose() {
    _navigationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Row(
            children: [
              // Left side - Feature content
              Expanded(flex: 3, child: _LeftPanel(l10n: l10n)),

              // Right side - Feature images and navigation
              Expanded(flex: 2, child: _RightPanel()),
            ],
          ),

          // Loading overlay
          if (tutorialState.isLoading)
            Container(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Error banner
          if (tutorialState.error != null)
            Positioned(
              bottom: 100,
              left: 24,
              right: 24,
              child: _ErrorBanner(error: tutorialState.error!),
            ),
        ],
      ),
    );
  }
}

class _LeftPanel extends ConsumerWidget {
  const _LeftPanel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final theme = Theme.of(context);

    // Define feature content
    final features = [
      {'title': l10n.spotlightTitle, 'description': l10n.spotlightDescription},
      {
        'title': l10n.personalizedTitle,
        'description': l10n.personalizedDescription,
      },
      {'title': l10n.discoverTitle, 'description': l10n.discoverDescription},
    ];

    final currentFeature = features[tutorialState.currentPage];

    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top header
          Row(
            children: [
              Flexible(
                child: SvgPicture.asset(
                  'assets/images/image_readian.svg',
                  height: 32,
                ),
              ),
              const Spacer(),
              Flexible(child: _LoginButton(l10n: l10n)),
            ],
          ),

          const SizedBox(height: 80),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome text
                Text(
                  'Welcome to',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                // Feature title
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    currentFeature['title']!,
                    key: ValueKey(tutorialState.currentPage),
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Feature description
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    currentFeature['description']!,
                    key: ValueKey('desc_${tutorialState.currentPage}'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.6,
                      fontSize: 18,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 48),

                // Bottom navigation
                Row(
                  children: [
                    _PaginationDots(currentPage: tutorialState.currentPage),
                    const SizedBox(width: 24),
                    _NextButton(l10n: l10n),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RightPanel extends ConsumerWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final theme = Theme.of(context);

    // Define image paths
    final images = [
      'assets/images/image_lamp.svg',
      'assets/images/image_glasses.svg',
      'assets/images/image_looking_glass.svg',
    ];

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SvgPicture.asset(
            images[tutorialState.currentPage],
            key: ValueKey(tutorialState.currentPage),
            width: 300,
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends ConsumerWidget {
  const _LoginButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);

    return ReadianButton(
      text: l10n.loginOrRegister,
      onPressed: tutorialState.isLoading
          ? null
          : () => ref.navigation(context).navigateToWelcome(),
      style: ReadianButtonStyle.outlinedSmall,
    );
  }
}

class _NextButton extends ConsumerWidget {
  const _NextButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final tutorialViewModel = ref.read(tutorialViewModelProvider.notifier);

    return ReadianButton(
      text: tutorialState.currentPage < 2 ? l10n.next : l10n.getStarted,
      onPressed: tutorialState.isLoading
          ? null
          : () => tutorialViewModel.handleNextAction(),
      style: ReadianButtonStyle.outlinedSmall,
    );
  }
}

class _PaginationDots extends StatelessWidget {
  const _PaginationDots({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: index == currentPage ? 24 : 12,
          height: 12,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: index == currentPage
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}

class _ErrorBanner extends ConsumerWidget {
  const _ErrorBanner({required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tutorialViewModel = ref.read(tutorialViewModelProvider.notifier);

    return Material(
      color: theme.colorScheme.error,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.onError),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              onPressed: () => tutorialViewModel.setError(null),
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onError,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
