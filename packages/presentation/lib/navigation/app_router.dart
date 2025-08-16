import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readian_features/features.dart';


class AppRouter {
  static const String tutorial = '/tutorial';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String home = '/home';
  static const String spotlight = '/spotlight';
  static const String subscriptions = '/subscriptions';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String postDetail = '/post/:id';

  static final GoRouter router = GoRouter(
    initialLocation: tutorial,
    routes: [
      // Onboarding routes
      GoRoute(
        path: tutorial,
        name: 'tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      
      // Auth routes (placeholder screens for now)
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const _PlaceholderScreen(title: 'Register'),
      ),
      
      // Main app routes will be added later
      // ShellRoute for bottom navigation...
    ],
  );
}

// Placeholder screen for development
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text('This screen will be implemented later'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.tutorial),
              child: const Text('Back to Tutorial'),
            ),
          ],
        ),
      ),
    );
  }
}