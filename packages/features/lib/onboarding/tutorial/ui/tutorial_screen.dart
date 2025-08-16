import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_presentation/presentation.dart';

import '../tutorial_view_model.dart';
import 'tutorial_desktop_layout.dart';
import 'tutorial_mobile_layout.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        tutorialViewModelProvider.overrideWith((ref) => TutorialViewModel()),
      ],
      child: Builder(
        builder: (context) {
          if (Responsive.shouldUseDesktopLayout(context)) {
            return const TutorialDesktopLayout();
          }
          return const TutorialMobileLayout();
        },
      ),
    );
  }
}

