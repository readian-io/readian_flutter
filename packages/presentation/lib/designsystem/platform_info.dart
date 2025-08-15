import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Platform detection utilities
class PlatformInfo {
  /// Check if running on web
  static bool get isWeb => kIsWeb;
  
  /// Check if running on mobile platforms
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  
  /// Check if running on desktop platforms
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  
  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  
  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  
  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  
  /// Get current platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  /// Check if platform supports multiple windows
  static bool get supportsMultipleWindows => isDesktop;
  
  /// Check if platform has touch input primarily
  static bool get isPrimaryTouchInput => isMobile;
  
  /// Check if platform supports hover interactions
  static bool get supportsHover => isDesktop || isWeb;
}

/// Extension on BuildContext for convenient platform access
extension PlatformContext on Never {
  // Note: We can't extend BuildContext directly, but you can use:
  // PlatformInfo.isDesktop in any widget
}