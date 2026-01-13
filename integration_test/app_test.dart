import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:auto_test_demo/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Reset router before each test
  setUp(() {
    router.go(AppPaths.home);
  });

  group('MyHomePage Integration Tests', () {
    testWidgets('should display initial counter value and verify home route',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Get and print current route path
      final currentLocation = router.routerDelegate.currentConfiguration.matches.last.matchedLocation;
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
      
      // Verify the "Go to Detail" button exists
      expect(find.text('Go to Detail'), findsOneWidget);
    });

    testWidgets('should increment counter when Increment button is tapped',
        (WidgetTester tester) async {
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
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we start on home page
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      debugPrint('Initial route: ${router.routerDelegate.currentConfiguration.matches.last.matchedLocation}');

      // Tap the "Go to Detail" button
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify current route is detail page
      final currentLocation = router.routerDelegate.currentConfiguration.matches.last.matchedLocation;
      debugPrint('After navigation route: $currentLocation');
      expect(currentLocation, equals(AppPaths.detail));

      // Verify we are on detail page
      expect(find.text('Detail Page'), findsOneWidget);
      expect(find.text('Counter value from Home:'), findsOneWidget);
      
      // Verify counter value passed is 0 (initial value)
      expect(find.byKey(const Key('detail_counter_value')), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should pass correct counter value to detail page after incrementing',
        (WidgetTester tester) async {
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
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to detail page
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();

      // Verify we are on detail page
      expect(find.text('Detail Page'), findsOneWidget);
      debugPrint('On detail page: ${router.routerDelegate.currentConfiguration.matches.last.matchedLocation}');

      // Tap the back button
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // Verify we are back on home page
      final currentLocation = router.routerDelegate.currentConfiguration.matches.last.matchedLocation;
      debugPrint('After back navigation: $currentLocation');
      expect(currentLocation, equals(AppPaths.home));
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('should preserve counter value after navigating back from detail',
        (WidgetTester tester) async {
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
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      // Verify counter is still 5 on home page
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should verify complete navigation flow',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Step 1: Verify initial state
      expect(router.routerDelegate.currentConfiguration.matches.last.matchedLocation, equals(AppPaths.home));
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
      expect(router.routerDelegate.currentConfiguration.matches.last.matchedLocation, equals(AppPaths.detail));
      expect(find.text('2'), findsOneWidget);
      debugPrint('Step 3: On detail page, counter = 2');

      // Step 4: Go back
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();
      expect(router.routerDelegate.currentConfiguration.matches.last.matchedLocation, equals(AppPaths.home));
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
}
