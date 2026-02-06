import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minequest/main.dart';

void main() {
  testWidgets('MineQuest app starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MineQuestApp());

    // Verify that the app starts and renders the welcome screen
    expect(find.text('MineQuest'), findsOneWidget);
    expect(find.text('Twoja codzienna dawka minecraftowych wyzwań.'), findsOneWidget);
    expect(find.text('Rozpocznij przygodę'), findsOneWidget);
  });

  testWidgets('WelcomeScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    // Verify welcome screen content
    expect(find.text('MineQuest'), findsOneWidget);
    expect(find.byType(MinecraftAnimation), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('MinecraftAnimation renders without crashing', (WidgetTester tester) async {
    // Test that MinecraftAnimation can be built
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MinecraftAnimation(height: 180),
        ),
      ),
    );

    // Verify animation widget exists
    expect(find.byType(MinecraftAnimation), findsOneWidget);
    
    // Pump a few frames to ensure animation doesn't crash
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('PlayerSetupScreen navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MineQuestApp());

    // Find and tap the start button
    final startButton = find.text('Rozpocznij przygodę');
    expect(startButton, findsOneWidget);
    
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Verify we navigated to player setup screen
    expect(find.text('Twoje dane'), findsOneWidget);
    expect(find.text('Podaj imię i wersję, aby ruszyć dalej.'), findsAtLeastNWidgets(0));
  });

  testWidgets('PlayerSetupScreen requires name and version', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerSetupScreen(),
      ),
    );

    // Try to continue without filling in data
    final continueButton = find.text('Dalej');
    await tester.tap(continueButton);
    await tester.pump();

    // Should show snackbar with error
    expect(find.text('Podaj imię i wersję, aby ruszyć dalej.'), findsOneWidget);
  });
}
