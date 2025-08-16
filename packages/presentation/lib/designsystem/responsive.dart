import 'package:flutter/material.dart';
import 'platform_info.dart';

/// Responsive breakpoints following common design patterns
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double desktopLarge = 1440;
}

/// Device type based on screen width
enum DeviceType { mobile, tablet, desktop, desktopLarge }

/// Responsive layout helper
class ResponsiveLayout {
  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= Breakpoints.desktopLarge) {
      return DeviceType.desktopLarge;
    } else if (width >= Breakpoints.desktop) {
      return DeviceType.desktop;
    } else if (width >= Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if current screen is tablet or larger
  static bool isTablet(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.tablet || isDesktop(context);
  }

  /// Check if current screen is desktop or larger
  static bool isDesktop(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.desktop ||
        deviceType == DeviceType.desktopLarge;
  }

  /// Check if should use desktop layout (combines screen size + platform)
  static bool shouldUseDesktopLayout(BuildContext context) {
    return isDesktop(context) || (PlatformInfo.isDesktop && isTablet(context));
  }

  /// Get responsive value based on device type
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.desktopLarge,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? desktopLarge;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout.responsive<Widget>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }
}

/// Extension on BuildContext for convenient access
extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => ResponsiveLayout.getDeviceType(this);
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) => ResponsiveLayout.responsive<T>(
    this,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    desktopLarge: desktopLarge,
  );
}
