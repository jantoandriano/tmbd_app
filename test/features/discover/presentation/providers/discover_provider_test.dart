import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  voteAverage: 7,
  releaseDate: '2024-01-01',
  overview: 'overview',
);

void main() {
  late MockDiscoverRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockDiscoverRepository();
    container = ProviderContainer(
      overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('build loads now playing and upcoming into state', () async {
    when(() => repository.getNowPlayingMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 5)),
    );
    when(() => repository.getUpcomingMovies(page: 1)).thenAnswer(
      (_) async => Right(
        PaginatedMovies(movies: [_movie(2), _movie(3)], page: 1, totalPages: 3),
      ),
    );

    final state = await container.read(discoverProvider.future);

    expect(state.nowPlaying, hasLength(1));
    expect(state.comingSoon, hasLength(2));
  });

  test(
    'build surfaces a now-playing repository failure as an AsyncError',
    () async {
      when(
        () => repository.getNowPlayingMovies(page: 1),
      ).thenAnswer((_) async => const Left(Failure.network('offline')));
      when(() => repository.getUpcomingMovies(page: 1)).thenAnswer(
        (_) async =>
            const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
      );

      container.listen(discoverProvider, (_, _) {});
      await container.pump();

      final state = container.read(discoverProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Failure>());
    },
  );

  test(
    'build surfaces an upcoming repository failure as an AsyncError',
    () async {
      when(() => repository.getNowPlayingMovies(page: 1)).thenAnswer(
        (_) async =>
            const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
      );
      when(
        () => repository.getUpcomingMovies(page: 1),
      ).thenAnswer((_) async => const Left(Failure.network('offline')));

      container.listen(discoverProvider, (_, _) {});
      await container.pump();

      final state = container.read(discoverProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Failure>());
    },
  );
}
