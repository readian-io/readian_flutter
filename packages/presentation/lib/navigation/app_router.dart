import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readian_features/features.dart';
import 'package:readian_features/onboarding/login/ui/login_screen.dart';
import 'package:readian_presentation/providers/auth_providers.dart';

class AppRouter {
  static const String tutorial = '/tutorial';
  static const String welcome = '/welcome';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String spotlight = '/spotlight';
  static const String subscriptions = '/subscriptions';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String postDetail = '/post/:id';

  static const onboardingRoutes = [tutorial, welcome, register, login];

  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: tutorial,
      redirect: (context, state) {
        final authState = ref.read(authenticationStoreProvider);
        final currentState = authState.currentState;

        return currentState.when(
          authenticated: (accessToken, refreshToken) {
            if (onboardingRoutes.contains(state.uri.path)) {
              return home;
            }
            return null;
          },
          unauthenticated: () {
            if (state.uri.path == home) {
              return tutorial;
            }
            return null;
          },
        );
      },
      routes: [
        GoRoute(
          path: tutorial,
          name: 'tutorial',
          builder: (context, state) => const TutorialScreen(),
        ),

        GoRoute(
          path: welcome,
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),

        GoRoute(
          path: register,
          name: 'register',
          builder: (context, state) =>
              const _PlaceholderScreen(title: 'Register'),
        ),

        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const _PlaceholderScreen(title: 'Home'),
        ),
      ],
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Watch the auth state to rebuild router when auth changes
  ref.watch(authStateProvider);
  return AppRouter.createRouter(ref);
});

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
