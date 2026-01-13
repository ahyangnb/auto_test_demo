import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_test_demo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Print the random number at test start
  debugPrint('=== Test Suite Started ===');
  debugPrint('AppConfig.randomNumber: ${AppConfig.randomNumber}');

  // Reset router and SharedPreferences before each test
  setUp(() async {
    debugPrint('--- Test Setup - Random Number: ${AppConfig.randomNumber} ---');
    router.go(AppPaths.home);
    SharedPreferences.setMockInitialValues({});
  });

  // Helper function to get current route path
  String getCurrentRoute() {
    return router.routerDelegate.currentConfiguration.matches.last.matchedLocation;
  }

  group('MyHomePage Integration Tests', () {
    testWidgets('should display initial counter value and verify home route',
        (WidgetTester tester) async {
      debugPrint('[Test] Initial counter - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Get and print current route path
      final currentLocation = getCurrentRoute();
      debugPrint('Current route path: $currentLocation');
      
      // Verify we are on the home route
      expect(currentLocation, equals(AppPaths.home));

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
      
      // Verify the "Go to Detail" and "Go to Note" buttons exist
      expect(find.text('Go to Detail'), findsOneWidget);
      expect(find.text('Go to Note'), findsOneWidget);
    });

    testWidgets('should increment counter when Increment button is tapped',
        (WidgetTester tester) async {
      debugPrint('[Test] Increment counter - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

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
      debugPrint('[Test] Increment multiple times - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

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

  group('Navigation Integration Tests', () {
    testWidgets('should navigate to detail page when "Go to Detail" button is tapped',
        (WidgetTester tester) async {
      debugPrint('[Test] Navigate to detail - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we start on home page
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      debugPrint('Initial route: ${getCurrentRoute()}');

      // Tap the "Go to Detail" button
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify current route is detail page
      final currentLocation = getCurrentRoute();
      debugPrint('After navigation route: $currentLocation');
      expect(currentLocation, equals(AppPaths.detail));

      // Verify we are on detail page
      expect(find.text('Detail Page'), findsOneWidget);
      expect(find.text('Counter value from Home:'), findsOneWidget);
      
      // Verify counter value passed is 0 (initial value)
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should pass correct counter value to detail page after incrementing',
        (WidgetTester tester) async {
      debugPrint('[Test] Pass counter to detail - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Increment counter 3 times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byTooltip('Increment'));
        await tester.pumpAndSettle();
      }

      // Verify counter is 3
      expect(find.text('3'), findsOneWidget);

      // Navigate to detail page
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify we are on detail page with counter value 3
      expect(find.text('Detail Page'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should navigate back to home page from detail page',
        (WidgetTester tester) async {
      debugPrint('[Test] Navigate back from detail - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to detail page
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify we are on detail page
      expect(find.text('Detail Page'), findsOneWidget);
      debugPrint('On detail page: ${getCurrentRoute()}');

      // Tap the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we are back on home page
      final currentLocation = getCurrentRoute();
      debugPrint('After back navigation: $currentLocation');
      expect(currentLocation, equals(AppPaths.home));
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('should preserve counter value after navigating back from detail',
        (WidgetTester tester) async {
      debugPrint('[Test] Preserve counter - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Increment counter 5 times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byTooltip('Increment'));
        await tester.pumpAndSettle();
      }

      // Verify counter is 5
      expect(find.text('5'), findsOneWidget);

      // Navigate to detail page
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify detail page shows 5
      expect(find.text('Detail Page'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify counter is still 5 on home page
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should verify complete navigation flow',
        (WidgetTester tester) async {
      debugPrint('[Test] Complete navigation flow - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Step 1: Verify initial state
      expect(getCurrentRoute(), equals(AppPaths.home));
      expect(find.text('0'), findsOneWidget);
      debugPrint('Step 1: Home page, counter = 0');

      // Step 2: Increment to 2
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      debugPrint('Step 2: Counter incremented to 2');

      // Step 3: Navigate to detail
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();
      expect(getCurrentRoute(), equals(AppPaths.detail));
      expect(find.text('2'), findsOneWidget);
      debugPrint('Step 3: On detail page, counter = 2');

      // Step 4: Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(getCurrentRoute(), equals(AppPaths.home));
      debugPrint('Step 4: Back on home page');

      // Step 5: Increment more
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);
      debugPrint('Step 5: Counter incremented to 3');

      // Step 6: Navigate to detail again
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);
      debugPrint('Step 6: On detail page, counter = 3');
    });
  });

  group('Note Page Integration Tests', () {
    testWidgets('should navigate to note page and display random number',
        (WidgetTester tester) async {
      debugPrint('[Test] Navigate to note page - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify "Go to Note" button exists
      expect(find.text('Go to Note'), findsOneWidget);

      // Tap the "Go to Note" button
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Verify we are on note page
      expect(getCurrentRoute(), equals(AppPaths.note));
      expect(find.text('Note Page'), findsOneWidget);

      // Verify random number is displayed
      expect(find.textContaining('Random Number:'), findsOneWidget);
      debugPrint('Random number displayed: ${AppConfig.randomNumber}');
    });

    testWidgets('should save and display note using SharedPreferences',
        (WidgetTester tester) async {
      debugPrint('[Test] Save note - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to note page
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Verify we are on note page
      expect(find.text('Note Page'), findsOneWidget);

      // Find the text field and enter a note
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      
      await tester.enterText(textField, 'Test note content');
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.text('Save Note'));
      await tester.pumpAndSettle();

      // Verify snackbar appears
      expect(find.text('Note saved successfully!'), findsOneWidget);

      // Verify saved note is displayed
      expect(find.text('Saved Note:'), findsOneWidget);
      expect(find.text('Test note content'), findsWidgets);
    });

    testWidgets('should clear note when clear button is tapped',
        (WidgetTester tester) async {
      debugPrint('[Test] Clear note - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to note page
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Enter and save a note
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Note to be cleared');
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Save Note'));
      await tester.pumpAndSettle();

      // Verify note is saved
      expect(find.text('Note to be cleared'), findsWidgets);

      // Clear the note
      await tester.tap(find.text('Clear Note'));
      await tester.pumpAndSettle();

      // Verify note is cleared
      expect(find.text('Saved Note:'), findsNothing);
    });

    testWidgets('should navigate back from note page to home',
        (WidgetTester tester) async {
      debugPrint('[Test] Navigate back from note - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to note page
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Verify we are on note page
      expect(find.text('Note Page'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we are back on home page
      expect(getCurrentRoute(), equals(AppPaths.home));
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('should persist note across navigation',
        (WidgetTester tester) async {
      debugPrint('[Test] Persist note - Random Number: ${AppConfig.randomNumber}');
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to note page
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Enter and save a note
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Persistent note');
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Save Note'));
      await tester.pumpAndSettle();

      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to note page again
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Verify note is still there
      expect(find.text('Persistent note'), findsWidgets);
    });

    testWidgets('should verify random number is consistent across app',
        (WidgetTester tester) async {
      debugPrint('[Test] Verify random number consistency - Random Number: ${AppConfig.randomNumber}');
      // Store the initial random number
      final randomNumber = AppConfig.randomNumber;
      debugPrint('Initial random number: $randomNumber');

      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to note page
      await tester.tap(find.text('Go to Note'));
      await tester.pumpAndSettle();

      // Verify random number is the same
      expect(AppConfig.randomNumber, equals(randomNumber));
      expect(find.text('Random Number: $randomNumber'), findsOneWidget);

      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Navigate to detail page
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify random number is still the same
      expect(AppConfig.randomNumber, equals(randomNumber));
      debugPrint('Random number after navigation: ${AppConfig.randomNumber}');
    });
  });
}
