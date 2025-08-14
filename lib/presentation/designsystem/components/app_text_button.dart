import 'package:flutter/material.dart';

class ReadianButton extends StatelessWidget {
  const ReadianButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
  });

  final String text;
  final VoidCallback? onPressed;
  final ReadianButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = style ?? ReadianButtonStyle.primary;

    return TextButton(
      onPressed: onPressed,
      style: buttonStyle.getButtonStyle(theme),
      child: Text(text, style: buttonStyle.getTextStyle(theme)),
    );
  }
}

enum ReadianButtonStyle {
  primary,
  secondary,
  small,
  outlined;

  TextStyle getTextStyle(ThemeData theme) {
    switch (this) {
      case ReadianButtonStyle.primary:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
      case ReadianButtonStyle.secondary:
        return TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        );
      case ReadianButtonStyle.small:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      case ReadianButtonStyle.outlined:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
    }
  }

  ButtonStyle? getButtonStyle(ThemeData theme) {
    switch (this) {
      case ReadianButtonStyle.outlined:
        return TextButton.styleFrom(
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        );
      case ReadianButtonStyle.primary:
      case ReadianButtonStyle.secondary:
      case ReadianButtonStyle.small:
        return null; // Use default TextButton style
    }
  }
}
