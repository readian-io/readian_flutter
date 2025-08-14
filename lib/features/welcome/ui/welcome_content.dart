import 'package:flutter/material.dart';
import '../../../presentation/designsystem/app_constants.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome message
        Text(
          'Welcome to Readian',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        
        // Description
        Text(
          'Discover amazing content and connect with readers.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        
        // Feature highlights
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FeatureItem(
              icon: Icons.star_rounded,
              label: 'Spotlight',
              theme: theme,
            ),
            _FeatureItem(
              icon: Icons.library_books_rounded,
              label: 'Library',
              theme: theme,
            ),
            _FeatureItem(
              icon: Icons.subscriptions_rounded,
              label: 'Subscribe',
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}