import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:auto_test_demo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MyHomePage Integration Tests', () {
    testWidgets('should display initial counter value and navigate correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Get and print current route path
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      final String? currentRoute = ModalRoute.of(navigator.context)?.settings.name;
      debugPrint('Current route path: $currentRoute');

      // Verify the app has navigated to MyHomePage (check title in AppBar)
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);

      // Verify the initial counter value is 0
      expect(find.text('0'), findsOneWidget);

      // Verify the description text is displayed
      expect(
          find.text('You have pushed the button this many times:'), findsOneWidget);

      // Verify the Increment button exists
      expect(find.byTooltip('Increment'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should increment counter when Increment button is tapped',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify initial counter value is 0
      expect(find.text('0'), findsOneWidget);

      // Tap the Increment button
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();

      // Verify the counter value is now 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);

      // Tap the Increment button again
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();

      // Verify the counter value is now 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('should increment counter multiple times',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Verify initial counter value is 0
      expect(find.text('0'), findsOneWidget);

      // Tap the Increment button 5 times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byTooltip('Increment'));
        await tester.pumpAndSettle();
      }

      // Verify the counter value is now 5
      expect(find.text('5'), findsOneWidget);
    });
  });
}
