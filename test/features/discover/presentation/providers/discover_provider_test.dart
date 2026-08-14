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

  test('build loads page 1 into state', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 5)),
    );

    final state = await container.read(discoverProvider.future);

    expect(state.movies, hasLength(1));
    expect(state.hasReachedMax, isFalse);
  });

  test('build surfaces a repository failure as an AsyncError', () async {
    when(
      () => repository.getPopularMovies(page: 1),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    container.listen(discoverProvider, (_, _) {});
    await container.pump();

    final state = container.read(discoverProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<Failure>());
  });

  test('loadNextPage appends movies and advances the page', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 2)),
    );
    when(() => repository.getPopularMovies(page: 2)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(2)], page: 2, totalPages: 2)),
    );

    await container.read(discoverProvider.future);
    final failure = await container
        .read(discoverProvider.notifier)
        .loadNextPage();

    final state = container.read(discoverProvider).value!;
    expect(failure, isNull);
    expect(state.movies, hasLength(2));
    expect(state.page, 2);
    expect(state.hasReachedMax, isTrue);
  });

  test('loadNextPage failure leaves existing movies untouched', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 5)),
    );
    when(
      () => repository.getPopularMovies(page: 2),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    await container.read(discoverProvider.future);
    final failure = await container
        .read(discoverProvider.notifier)
        .loadNextPage();

    final state = container.read(discoverProvider).value!;
    expect(failure, isA<NetworkFailure>());
    expect(state.movies, hasLength(1));
    expect(state.isLoadingMore, isFalse);
  });

  test('loadNextPage is a no-op once hasReachedMax is true', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 1)),
    );

    await container.read(discoverProvider.future);
    final failure = await container
        .read(discoverProvider.notifier)
        .loadNextPage();

    expect(failure, isNull);
    verifyNever(() => repository.getPopularMovies(page: 2));
  });
}
