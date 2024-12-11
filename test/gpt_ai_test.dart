import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gpt_ai/gpt_ai.dart';

void main() {
  setUp(() {
    Get.reset(); // Reset GetX state before each test
  });

  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial state shows empty chat
    expect(find.text('No messages yet'), findsOneWidget);
    expect(
        find.text('Start a conversation by sending a message'), findsOneWidget);
  });

  testWidgets('Send message test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enter text in the input field
    await tester.enterText(
        find.byType(TextField), 'Hello, this is a test message');

    // Tap the send button
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    // Verify that the message appears in the chat
    expect(find.text('Hello, this is a test message'), findsOneWidget);
  });

  test('MessageModel test', () {
    final timestamp = DateTime.now();
    final message = MessageModel(
      message: 'Test message',
      timestamp: timestamp,
    );

    expect(message.message, 'Test message');
    expect(message.timestamp, timestamp);
  });

  testWidgets('Theme toggle test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Get the ThemeController
    final ThemeController controller = Get.find<ThemeController>();

    // Verify initial dark mode state
    expect(controller.isDarkMode.value, true);

    // Toggle theme
    controller.toggleTheme();
    await tester.pump();

    // Verify theme was toggled
    expect(controller.isDarkMode.value, false);
  });
}
