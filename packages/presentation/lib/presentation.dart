import 'package:flutter/material.dart';
import 'designsystem/responsive.dart';

export 'designsystem/app_constants.dart';
export 'designsystem/app_theme.dart';
export 'designsystem/components/buttons.dart';
export 'designsystem/platform_info.dart';
export 'designsystem/responsive.dart';
export 'navigation/app_router.dart';
export 'navigation/navigation_service.dart';
export 'navigation/navigation_providers.dart';
export 'providers/app_providers.dart';

// Aliases for easier access - using class instead of typedef
class Responsive {
  static bool shouldUseDesktopLayout(BuildContext context) =>
      ResponsiveLayout.shouldUseDesktopLayout(context);

  static bool isMobile(BuildContext context) =>
      ResponsiveLayout.isMobile(context);

  static bool isTablet(BuildContext context) =>
      ResponsiveLayout.isTablet(context);

  static bool isDesktop(BuildContext context) =>
      ResponsiveLayout.isDesktop(context);

  static DeviceType getDeviceType(BuildContext context) =>
      ResponsiveLayout.getDeviceType(context);

  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) => ResponsiveLayout.responsive<T>(
    context,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    desktopLarge: desktopLarge,
  );
}
