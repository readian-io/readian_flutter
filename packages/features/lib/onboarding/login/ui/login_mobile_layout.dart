import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';
import 'package:readian_presentation/presentation.dart';
import '../state/login_form_provider.dart';

class LoginMobileLayout extends ConsumerWidget {
  const LoginMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navigation = ref.navigation(context);
    final l10n = AppLocalizations.of(context);

    final hasEmailError = ref.watch(hasEmailErrorProvider);
    final hasPasswordError = ref.watch(hasPasswordErrorProvider);
    final isFormValid = ref.watch(isFormValidProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => navigation.goBack(),
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 64),
            Text(l10n.login, style: theme.textTheme.titleLarge),

            const SizedBox(height: 64),

            ReadianTextField(
              labelText: l10n.email,
              hasError: hasEmailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  ref.read(emailProvider.notifier).state = value,
            ),

            const SizedBox(height: 8),

            ReadianTextField(
              labelText: l10n.password,
              hasError: hasPasswordError,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onChanged: (value) =>
                  ref.read(passwordProvider.notifier).state = value,
            ),

            const SizedBox(height: 8),

            ReadianButton(
              text: "Forgot password",
              onPressed: () {},
              style: ReadianButtonStyle.tertiary,
            ),

            const SizedBox(height: 8),

            ReadianButton(
              text: l10n.login,
              onPressed: isFormValid
                  ? () {
                      // TODO: Add actual login logic here
                      // For now, navigate to home after successful login
                      ref.navigation(context).navigateToHome();
                    }
                  : null,
              style: ReadianButtonStyle.primary,
              enabled: isFormValid,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),

            const SizedBox(height: 24),

            TermsView(
              byJoiningText: l10n.byJoining,
              privacyPolicyText: l10n.privacyPolicy,
              andText: l10n.and,
              termsOfServiceText: l10n.termsOfService,
            ),
          ],
        ),
      ),
    );
  }
}
