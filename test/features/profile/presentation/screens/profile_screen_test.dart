import 'package:cinetrack/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget wrap() {
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) =>
              const Scaffold(body: Text('Settings stub')),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) =>
              const Scaffold(body: Text('Account stub')),
        ),
      ],
    );
    return ProviderScope(child: MaterialApp.router(routerConfig: router));
  }

  testWidgets('renders profile header, stats, and menu rows', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Alex Rivera'), findsOneWidget);
    expect(find.text('alex.rivera@email.com'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Payment Methods'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('tapping a menu row navigates to its route', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();

    expect(find.text('Account stub'), findsOneWidget);
  });

  testWidgets('tapping the settings icon navigates to /settings', (
    tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings stub'), findsOneWidget);
  });

  testWidgets('tapping Sign Out shows a stub snackbar', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Sign Out'), 200);
    await tester.tap(find.text('Sign Out'));
    await tester.pump();

    expect(find.text('Signed out'), findsOneWidget);
  });
}
