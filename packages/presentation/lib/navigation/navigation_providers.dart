import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'go_router_navigation_service.dart';
import 'navigation_service.dart';

/// Provider for NavigationService
/// Requires BuildContext to be passed when reading
final navigationServiceProvider = Provider.family<NavigationService, BuildContext>(
  (ref, context) => GoRouterNavigationService(context),
);

/// Extension to easily access navigation service from WidgetRef
extension NavigationExtension on WidgetRef {
  NavigationService navigation(BuildContext context) {
    return read(navigationServiceProvider(context));
  }
}