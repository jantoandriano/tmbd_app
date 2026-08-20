import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_provider.dart';
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

  test('build loads the first page for the given list type', () async {
    when(() => repository.getNowPlayingMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 2)),
    );

    final state = await container.read(
      movieListProvider(MovieListType.nowPlaying).future,
    );

    expect(state.movies, hasLength(1));
    expect(state.page, 1);
    expect(state.totalPages, 2);
    verifyNever(() => repository.getUpcomingMovies(page: any(named: 'page')));
  });

  test('loadMore appends the next page and advances page', () async {
    when(() => repository.getUpcomingMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 2)),
    );
    when(() => repository.getUpcomingMovies(page: 2)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(2)], page: 2, totalPages: 2)),
    );

    await container.read(movieListProvider(MovieListType.comingSoon).future);
    await container
        .read(movieListProvider(MovieListType.comingSoon).notifier)
        .loadMore();

    final state = container.read(movieListProvider(MovieListType.comingSoon));
    expect(state.value!.movies.map((m) => m.id), [1, 2]);
    expect(state.value!.page, 2);
  });

  test('loadMore is a no-op once the last page is reached', () async {
    when(() => repository.getUpcomingMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 1)),
    );

    await container.read(movieListProvider(MovieListType.comingSoon).future);
    await container
        .read(movieListProvider(MovieListType.comingSoon).notifier)
        .loadMore();

    verifyNever(() => repository.getUpcomingMovies(page: 2));
  });
}
