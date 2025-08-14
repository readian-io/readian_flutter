// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:readian_flutter/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Set a large screen size to avoid overflow
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ReadianApp()));

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that welcome screen is displayed
    expect(find.byType(SvgPicture), findsWidgets);
    expect(find.text('Spotlight'), findsOneWidget);
    expect(find.text('Login or Register'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    
    addTearDown(tester.view.reset);
  });
}
