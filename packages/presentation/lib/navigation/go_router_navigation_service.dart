import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'navigation_service.dart';

/// Concrete implementation of NavigationService using go_router
class GoRouterNavigationService implements NavigationService {
  final BuildContext _context;

  const GoRouterNavigationService(this._context);

  @override
  void navigateToTutorial() {
    _context.go(AppRouter.tutorial);
  }

  @override
  void navigateToWelcome() {
    _context.go(AppRouter.welcome);
  }

  @override
  void navigateToRegister() {
    _context.go(AppRouter.register);
  }

  @override
  void navigateToHome() {
    _context.go(AppRouter.home);
  }

  @override
  void navigateToPostDetail(String postId) {
    _context.go(AppRouter.postDetail.replaceAll(':id', postId));
  }

  @override
  void navigateToProfile() {
    _context.go(AppRouter.profile);
  }

  @override
  void navigateToLibrary() {
    _context.go(AppRouter.library);
  }

  @override
  void navigateToSubscriptions() {
    _context.go(AppRouter.subscriptions);
  }

  @override
  void navigateToSpotlight() {
    _context.go(AppRouter.spotlight);
  }

  @override
  void goBack() {
    if (canGoBack()) {
      _context.pop();
    }
  }

  @override
  bool canGoBack() {
    return _context.canPop();
  }

  @override
  void replace(String route) {
    _context.pushReplacement(route);
  }

  @override
  void pushAndClearStack(String route) {
    _context.go(route);
  }
}
