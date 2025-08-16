import 'package:flutter/material.dart';

/// Design tokens for ReadianButton component
class ButtonTokens {
  static const double borderRadius = 28.0;
  static const double smallBorderRadius = 8.0;
  static const double height = 52.0;
  static const double smallHeight = 36.0;
  static const double fontSize = 18.0;
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double borderWidth = 1.0;
  static const double thickBorderWidth = 2.0;
  static const EdgeInsets smallPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
}

class ReadianButton extends StatelessWidget {
  const ReadianButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  final String text;
  final VoidCallback? onPressed;
  final ReadianButtonStyle? style;
  final Widget? icon;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = style ?? ReadianButtonStyle.primary;

    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = _buildButtonChild(buttonStyle, theme);
    final button = _buildButton(buttonStyle, theme, effectiveOnPressed, child);

    // Apply width constraints
    final effectiveWidth =
        width ??
        (buttonStyle == ReadianButtonStyle.primary ||
                buttonStyle == ReadianButtonStyle.outlined
            ? double.infinity
            : null);

    if (effectiveWidth != null) {
      return SizedBox(width: effectiveWidth, child: button);
    }

    return button;
  }

  Widget _buildButton(
    ReadianButtonStyle buttonStyle,
    ThemeData theme,
    VoidCallback? onPressed,
    Widget child,
  ) {
    return switch (buttonStyle) {
      ReadianButtonStyle.primary => ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle.getButtonStyle(theme),
        child: child,
      ),
      ReadianButtonStyle.outlined ||
      ReadianButtonStyle.outlinedSmall => OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle.getButtonStyle(theme),
        child: child,
      ),
      ReadianButtonStyle.text => TextButton(
        onPressed: onPressed,
        style: buttonStyle.getButtonStyle(theme),
        child: child,
      ),
    };
  }

  Widget _buildButtonChild(ReadianButtonStyle buttonStyle, ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonStyle == ReadianButtonStyle.primary
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: buttonStyle.getTextStyle(theme)),
        ],
      );
    }

    return Text(text, style: buttonStyle.getTextStyle(theme));
  }
}

enum ReadianButtonStyle {
  primary,
  outlined,
  text,
  outlinedSmall;

  TextStyle getTextStyle(ThemeData theme) {
    switch (this) {
      case ReadianButtonStyle.primary:
        return TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: ButtonTokens.fontSize,
          fontWeight: FontWeight.normal,
        );
      case ReadianButtonStyle.outlined:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: ButtonTokens.fontSize,
          fontWeight: FontWeight.normal,
        );
      case ReadianButtonStyle.text:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: ButtonTokens.smallFontSize,
          fontWeight: FontWeight.normal,
        );
      case ReadianButtonStyle.outlinedSmall:
        return TextStyle(
          color: theme.colorScheme.primary,
          fontSize: ButtonTokens.mediumFontSize,
          fontWeight: FontWeight.normal,
        );
    }
  }

  ButtonStyle? getButtonStyle(ThemeData theme) {
    switch (this) {
      case ReadianButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ButtonTokens.borderRadius),
          ),
          elevation: 0,
          minimumSize: Size(0, ButtonTokens.height),
        );
      case ReadianButtonStyle.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: ButtonTokens.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ButtonTokens.borderRadius),
          ),
          minimumSize: Size(0, ButtonTokens.height),
        );
      case ReadianButtonStyle.outlinedSmall:
        return OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: ButtonTokens.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ButtonTokens.smallBorderRadius),
          ),
          padding: ButtonTokens.smallPadding,
          minimumSize: Size(0, ButtonTokens.smallHeight),
        );
      case ReadianButtonStyle.text:
        return null; // Use default TextButton style
    }
  }
}
