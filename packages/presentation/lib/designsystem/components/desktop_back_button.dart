import 'package:flutter/material.dart';

class DesktopBackButton extends StatelessWidget {
  const DesktopBackButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_back,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
