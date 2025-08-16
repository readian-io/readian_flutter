import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readian_presentation/designsystem/components/buttons.dart';

import '../welcome_view_model.dart';

class WelcomeMobileLayout extends ConsumerWidget {
  const WelcomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeState = ref.watch(welcomeViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  SvgPicture.asset(
                    'assets/images/image_readian_logo_with_r.svg',
                    height:36,
                  ),

                  const SizedBox(height: 40),

                  SvgPicture.asset(
                    'assets/images/image_bookmark_wide.svg',
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 80),

                  // Buttons Section
                  _buildButtonsSection(context),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (welcomeState.loading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterIllustration() {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 120,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Stack(
              children: [
                // Eyes
                Positioned(
                  top: 40,
                  left: 30,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 30,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Arms
                Positioned(
                  right: -20,
                  top: 80,
                  child: Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    transform: Matrix4.rotationZ(0.3),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: 80,
                  child: Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    transform: Matrix4.rotationZ(-0.3),
                  ),
                ),
                // Legs
                Positioned(
                  bottom: -20,
                  left: 20,
                  child: Container(
                    width: 3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  right: 20,
                  child: Container(
                    width: 3,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating document cards
        ..._buildFloatingCards(),
      ],
    );
  }

  List<Widget> _buildFloatingCards() {
    final cards = <Widget>[];
    final positions = [
      {'left': 20.0, 'top': 50.0, 'rotation': -0.2},
      {'left': 80.0, 'top': 30.0, 'rotation': 0.1},
      {'right': 30.0, 'top': 80.0, 'rotation': 0.3},
      {'left': 40.0, 'bottom': 100.0, 'rotation': -0.1},
      {'right': 60.0, 'bottom': 120.0, 'rotation': 0.2},
      {'left': 10.0, 'top': 150.0, 'rotation': 0.15},
      {'right': 10.0, 'top': 160.0, 'rotation': -0.25},
    ];

    for (var i = 0; i < positions.length; i++) {
      final pos = positions[i];
      cards.add(
        Positioned(
          left: pos['left'] as double?,
          right: pos['right'] as double?,
          top: pos['top'] as double?,
          bottom: pos['bottom'] as double?,
          child: Transform.rotate(
            angle: pos['rotation'] as double,
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Container(width: 30, height: 2, color: Colors.grey[400]),
                  const SizedBox(height: 2),
                  Container(width: 25, height: 2, color: Colors.grey[400]),
                  const SizedBox(height: 2),
                  Container(width: 28, height: 2, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return cards;
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      children: [
        ReadianButton(
          text: 'Login',
          onPressed: () {
            // Handle login
          },
          style: ReadianButtonStyle.primary,
        ),

        const SizedBox(height: 8),

        ReadianButton(
          text: 'Register',
          onPressed: () {
            // Handle register
          },
          style: ReadianButtonStyle.outlined,
        ),

        const SizedBox(height: 24),

        ReadianButton(
          onPressed: () {
            // Handle skip
          },
          text: 'Skip',
          style: ReadianButtonStyle.text,
        ),
      ],
    );
  }
}
