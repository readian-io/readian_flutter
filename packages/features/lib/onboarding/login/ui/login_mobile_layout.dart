import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';
import 'package:readian_presentation/presentation.dart';
import 'package:readian_presentation/providers/auth_providers.dart';
import '../state/login_form_provider.dart';
import '../login_view_model.dart';

class LoginMobileLayout extends ConsumerWidget {
  const LoginMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navigation = ref.navigation(context);
    final l10n = AppLocalizations.of(context);

    final hasUsernameError = ref.watch(hasUsernameErrorProvider);
    final hasPasswordError = ref.watch(hasPasswordErrorProvider);
    final isFormValid = ref.watch(isFormValidProvider);
    
    final loginState = ref.watch(loginViewModelProvider);
    final email = ref.watch(usernameProvider);
    final password = ref.watch(passwordProvider);

    // Listen to authentication state changes
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        authState.whenOrNull(
          authenticated: (accessToken, refreshToken) {
            navigation.navigateToHome();
          },
        );
      });
    });

    // Show error dialog if login fails
    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.error != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text(next.error!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(loginViewModelProvider.notifier).clearError();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });

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
              labelText: 'Username',
              hasError: hasUsernameError,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  ref.read(usernameProvider.notifier).state = value,
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
              onPressed: isFormValid && !loginState.isLoading
                  ? () {
                      ref.read(loginViewModelProvider.notifier).login(email, password);
                    }
                  : null,
              style: ReadianButtonStyle.primary,
              enabled: isFormValid && !loginState.isLoading,
              isLoading: loginState.isLoading,
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
