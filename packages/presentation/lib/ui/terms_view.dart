import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsView extends StatelessWidget {
  const TermsView({
    super.key,
    required this.byJoiningText,
    required this.privacyPolicyText,
    required this.andText,
    required this.termsOfServiceText,
    this.textAlign = TextAlign.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 64),
  });

  final String byJoiningText;
  final String privacyPolicyText;
  final String andText;
  final String termsOfServiceText;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;

  static const String privacyLink = 'https://readian.io/privacy';
  static const String termsLink = 'https://readian.io/terms';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowEmphasisColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final normalColor = theme.colorScheme.onSurface;

    return Padding(
      padding: padding,
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          style: theme.textTheme.labelMedium?.copyWith(color: lowEmphasisColor),
          children: [
            TextSpan(text: '$byJoiningText '),
            TextSpan(
              text: privacyPolicyText,
              style: TextStyle(color: normalColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openUrl(privacyLink),
            ),
            TextSpan(text: ' $andText '),
            TextSpan(
              text: termsOfServiceText,
              style: TextStyle(color: normalColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _openUrl(termsLink),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
