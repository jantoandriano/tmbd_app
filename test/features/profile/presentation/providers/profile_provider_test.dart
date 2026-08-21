import 'package:cinetrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('build returns the stub profile state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(profileProvider);

    expect(state.name, 'Alex Rivera');
    expect(state.email, 'alex.rivera@email.com');
    expect(state.watchedCount, 128);
    expect(state.reviewsCount, 16);
  });
}
