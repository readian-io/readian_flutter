import 'package:go_router/go_router.dart';

import '../../features/welcome/ui/welcome_screen.dart';


class AppRouter {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String spotlight = '/spotlight';
  static const String subscriptions = '/subscriptions';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String postDetail = '/post/:id';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    routes: [
      // Onboarding routes
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      // TODO: Add other routes
      // GoRoute(
      //   path: login,
      //   name: 'login',
      //   builder: (context, state) => const LoginScreen(),
      // ),
      
      // GoRoute(
      //   path: register,
      //   name: 'register',
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      
      // Main app routes will be added later
      // ShellRoute for bottom navigation...
    ],
  );
}