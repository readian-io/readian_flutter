import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_features/onboarding/welcome/ui/welcome_mobile_layout.dart';
import 'package:readian_features/onboarding/welcome/ui/welcome_desktop_layout.dart';
import 'package:readian_presentation/presentation.dart';

import '../welcome_view_model.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        welcomeViewModelProvider.overrideWith((ref) => WelcomeViewModel()),
      ],
      child: Builder(
        builder: (context) {
          if (Responsive.shouldUseDesktopLayout(context)) {
            return const WelcomeDesktopLayout();
          }
          return const WelcomeMobileLayout();
        },
      ),
    );
  }
}
