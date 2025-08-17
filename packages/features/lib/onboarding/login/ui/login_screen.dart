import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_presentation/presentation.dart';

import 'login_desktop_layout.dart';
import 'login_mobile_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // welcomeViewModelProvider.overrideWith((ref) => WelcomeViewModel()),
      ],
      child: Builder(
        builder: (context) {
          if (Responsive.shouldUseDesktopLayout(context)) {
            return const LoginDesktopLayout();
          }
          return const LoginMobileLayout();
        },
      ),
    );
  }
}
