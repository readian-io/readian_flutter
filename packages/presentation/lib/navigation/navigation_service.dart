import 'package:flutter/material.dart';

/// Abstract navigation service for handling app navigation
/// This allows us to abstract away the specific routing implementation
abstract class NavigationService {
  void navigateToTutorial();

  void navigateToWelcome();

  void navigateToRegister();

  void navigateToHome();

  void navigateToPostDetail(String postId);

  void navigateToProfile();

  void navigateToLibrary();

  void navigateToSubscriptions();

  void navigateToSpotlight();

  void goBack();

  bool canGoBack();

  void replace(String route);

  void pushAndClearStack(String route);
}