import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../presentation/designsystem/components/app_text_button.dart';
import '../../../presentation/l10n/app_localizations.dart';
import '../welcome_view_model.dart';

/// Mobile-specific layout for welcome screen
/// Features: Vertical PageView with stacked content
class WelcomeMobileLayout extends ConsumerWidget {
  const WelcomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final theme = Theme.of(context);
    final pageController = PageController(
      initialPage: welcomeState.currentPage,
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
                  child: _TopContent(),
                ),

                const SizedBox(height: 64),

                Expanded(
                  child: _FeaturePageContent(pageController: pageController),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _BottomContent(),
                ),
              ],
            ),
          ),
          
          // Loading overlay
          if (welcomeState.isLoading)
            Container(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // Error snackbar
          if (welcomeState.error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: _ErrorBanner(error: welcomeState.error!),
            ),
        ],
      ),
    );
  }
}

class _TopContent extends ConsumerWidget {
  const _TopContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/images/image_readian.svg', height: 22),
        ReadianButton(
          text: l10n.loginOrRegister,
          onPressed: welcomeState.isLoading ? null : () => welcomeViewModel.navigateToLogin(context),
          style: ReadianButtonStyle.small,
        ),
      ],
    );
  }
}

class _FeaturePageContent extends ConsumerWidget {
  const _FeaturePageContent({required this.pageController});
  
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);

    // Sync PageController with state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients &&
          pageController.page?.round() != welcomeState.currentPage) {
        pageController.animateToPage(
          welcomeState.currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return PageView(
      controller: pageController,
      onPageChanged: welcomeViewModel.onPageChanged,
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
  const _BottomContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PaginationDots(currentPage: welcomeState.currentPage),
        ReadianButton(
          text: l10n.next,
          onPressed: welcomeState.isLoading ? null : () => welcomeViewModel.handleNextAction(context),
          style: ReadianButtonStyle.outlined,
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
    final welcomeViewModel = ref.read(welcomeViewModelProvider.notifier);
    
    return Material(
      color: theme.colorScheme.error,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onError,
            ),
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
              onPressed: () => welcomeViewModel.setError(null),
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