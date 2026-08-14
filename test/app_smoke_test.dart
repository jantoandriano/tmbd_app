import 'package:cinetrack/bootstrap.dart';
import 'package:cinetrack/core/di/injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders placeholder home route', (tester) async {
    await configureDependencies();

    await tester.pumpWidget(
      const ProviderScope(child: CineTrackApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('CineTrack — setup complete'), findsOneWidget);
  });
}
