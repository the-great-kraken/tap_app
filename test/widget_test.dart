import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tap_app/main.dart';

void main() {
  testWidgets('Color changing on tap test', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: MyApp()));

    // Check color on startup
    Color? _startColor =
        (tester.firstWidget(find.byType(Material)) as Material).color;

    // Find and tap on the text and trigger a frame
    await tester.tap(find.text('Hey there!'));
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify that color change after tap
    expect(
      (tester.firstWidget(find.byType(Material)) as Material).color,
      isNot(_startColor),
    );

    _startColor = (tester.firstWidget(find.byType(Material)) as Material).color;

    // Tap using offset coordinate and trigger a frame
    await tester.tapAt(Offset.zero);
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify that color change after tap
    expect(
      (tester.firstWidget(find.byType(Material)) as Material).color,
      isNot(_startColor),
    );
  });

  testWidgets('Snakbar test', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: MyApp()));

    const String _snackBarText = 'Tap on the screen!';

    // Verify that SnackBar is displayed
    expect(find.text(_snackBarText), findsNothing);
    await tester.pump();
    expect(find.text(_snackBarText), findsOneWidget);
  });
}
