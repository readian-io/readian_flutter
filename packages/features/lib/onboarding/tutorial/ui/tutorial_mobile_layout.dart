import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readian_presentation/presentation.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';

import '../tutorial_view_model.dart';
import '../state/tutorial_state.dart';

/// Mobile-specific layout for tutorial screen
/// Features: Vertical PageView with stacked content
class TutorialMobileLayout extends ConsumerStatefulWidget {
  const TutorialMobileLayout({super.key});

  @override
  ConsumerState<TutorialMobileLayout> createState() =>
      _TutorialMobileLayoutState();
}

class _TutorialMobileLayoutState extends ConsumerState<TutorialMobileLayout> {
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
    final pageController = PageController(
      initialPage: tutorialState.currentPage,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _TopContent(l10n: l10n),
                ),

                const SizedBox(height: 64),

                Expanded(
                  child: _FeaturePageContent(
                    pageController: pageController,
                    l10n: l10n,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _BottomContent(l10n: l10n),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (tutorialState.isLoading)
            Container(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Error snackbar
          if (tutorialState.error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: _ErrorBanner(error: tutorialState.error!),
            ),
        ],
      ),
    );
  }
}

class _TopContent extends ConsumerWidget {
  const _TopContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/images/image_readian.svg', height: 22),
        ReadianButton(
          text: l10n.loginOrRegister,
          onPressed: tutorialState.isLoading
              ? null
              : () => ref.navigation(context).navigateToWelcome(),
          style: ReadianButtonStyle.tertiary,
        ),
      ],
    );
  }
}

class _FeaturePageContent extends ConsumerWidget {
  const _FeaturePageContent({required this.pageController, required this.l10n});

  final AppLocalizations l10n;
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final tutorialViewModel = ref.read(tutorialViewModelProvider.notifier);

    // Sync PageController with state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients &&
          pageController.page?.round() != tutorialState.currentPage) {
        pageController.animateToPage(
          tutorialState.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return PageView(
      controller: pageController,
      onPageChanged: tutorialViewModel.onPageChanged,
      children: [
        _FeaturePage(
          imagePath: 'assets/images/image_lamp.svg',
          title: l10n.spotlightTitle,
          description: l10n.spotlightDescription,
        ),
        _FeaturePage(
          imagePath: 'assets/images/image_glasses.svg',
          title: l10n.personalizedTitle,
          description: l10n.personalizedDescription,
        ),
        _FeaturePage(
          imagePath: 'assets/images/image_looking_glass.svg',
          title: l10n.discoverTitle,
          description: l10n.discoverDescription,
        ),
      ],
    );
  }
}

class _FeaturePage extends StatelessWidget {
  const _FeaturePage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(imagePath, width: 88, height: 138),
          ),
          const SizedBox(height: 64),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomContent extends ConsumerWidget {
  const _BottomContent({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorialState = ref.watch(tutorialViewModelProvider);
    final tutorialViewModel = ref.read(tutorialViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PaginationDots(currentPage: tutorialState.currentPage),
        ReadianButton(
          text: l10n.next,
          onPressed: tutorialState.isLoading
              ? null
              : () => tutorialViewModel.handleNextAction(),
          style: ReadianButtonStyle.outlinedSmall,
        ),
      ],
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
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: index == currentPage
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.onError),
            const SizedBox(width: 12),
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
