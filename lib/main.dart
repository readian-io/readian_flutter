import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_flutter/presentation/navigation/app_router.dart';
import 'presentation/designsystem/app_constants.dart';
import 'presentation/designsystem/app_theme.dart';
import 'presentation/providers/app_providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ReadianApp(),
    ),
  );
}

class ReadianApp extends ConsumerWidget {
  const ReadianApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
