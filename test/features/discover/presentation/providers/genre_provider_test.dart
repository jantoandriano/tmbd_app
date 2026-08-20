import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/domain/entities/genre.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/genre_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

void main() {
  test('genreMap resolves ids to names', () async {
    final repository = MockDiscoverRepository();
    when(repository.getGenres).thenAnswer(
      (_) async => const Right([Genre(id: 28, name: 'Action')]),
    );

    final container = ProviderContainer(
      overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final map = await container.read(genreMapProvider.future);

    expect(map, {28: 'Action'});
  });

  test('genreMap falls back to empty on failure', () async {
    final repository = MockDiscoverRepository();
    when(
      repository.getGenres,
    ).thenAnswer((_) async => const Left(NetworkFailure('offline')));

    final container = ProviderContainer(
      overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final map = await container.read(genreMapProvider.future);

    expect(map, isEmpty);
  });
}
