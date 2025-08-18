import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';
import 'package:readian_presentation/presentation.dart';

import '../state/login_form_provider.dart';

class LoginDesktopLayout extends ConsumerWidget {
  const LoginDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildLeftPanel(context)),
            Expanded(flex: 1, child: _buildRightPanel(context, ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 120,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),

          const SizedBox(height: 24),

          Text(
            l10n.welcomeTo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),

          Text(
            l10n.appName,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _buildLoginForm(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final navigation = ref.navigation(context);

    final hasEmailError = ref.watch(hasUsernameErrorProvider);
    final hasPasswordError = ref.watch(hasPasswordErrorProvider);
    final isFormValid = ref.watch(isFormValidProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, navigation, l10n),

        const SizedBox(height: 48),

        _buildFormFields(context, ref, l10n, hasEmailError, hasPasswordError),

        const SizedBox(height: 16),

        _buildActionButtons(context, ref, l10n, isFormValid),

        const SizedBox(height: 32),

        _buildTermsView(l10n),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, navigation, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Row(
      children: [
        DesktopBackButton(onPressed: () => navigation.goBack()),
        Expanded(
          child: Text(
            l10n.login,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildFormFields(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool hasEmailError,
    bool hasPasswordError,
  ) {
    return Column(
      children: [
        ReadianTextField(
          labelText: l10n.email,
          hasError: hasEmailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (value) => ref.read(usernameProvider.notifier).state = value,
          padding: EdgeInsets.zero,
        ),

        const SizedBox(height: 16),

        ReadianTextField(
          labelText: l10n.password,
          hasError: hasPasswordError,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onChanged: (value) =>
              ref.read(passwordProvider.notifier).state = value,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isFormValid,
  ) {
    return Column(
      children: [
        ReadianButton(
          text: l10n.forgotPassword,
          onPressed: () {},
          style: ReadianButtonStyle.tertiary,
          padding: EdgeInsets.zero,
        ),

        const SizedBox(height: 24),

        ReadianButton(
          text: l10n.login,
          onPressed: isFormValid
              ? () => ref.navigation(context).navigateToHome()
              : null,
          style: ReadianButtonStyle.primary,
          enabled: isFormValid,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildTermsView(AppLocalizations l10n) {
    return TermsView(
      byJoiningText: l10n.byJoining,
      privacyPolicyText: l10n.privacyPolicy,
      andText: l10n.and,
      termsOfServiceText: l10n.termsOfService,
      padding: EdgeInsets.zero,
    );
  }
}
