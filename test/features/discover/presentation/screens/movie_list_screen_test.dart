import 'package:cinetrack/features/discover/domain/entities/genre.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_provider.dart';
import 'package:cinetrack/features/discover/presentation/screens/movie_list_screen.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_list_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_discover_repository.dart';

Movie _movie(int id, {List<int> genreIds = const []}) => Movie(
  id: id,
  title: 'Movie $id',
  voteAverage: 7,
  releaseDate: '2024-01-01',
  overview: 'overview',
  genreIds: genreIds,
);

void main() {
  testWidgets('renders the title and the fetched movies', (tester) async {
    final repository = FakeDiscoverRepository(
      Right(
        PaginatedMovies(
          movies: [_movie(1), _movie(2)],
          page: 1,
          totalPages: 1,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: MovieListScreen(
            args: MovieListArgs(
              title: 'Now Playing',
              type: MovieListType.nowPlaying,
              showReleaseDate: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.byType(MovieGridItem), findsNWidgets(2));
  });

  testWidgets('toggling to list mode swaps the grid for row items', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      Right(
        PaginatedMovies(movies: [_movie(1), _movie(2)], page: 1, totalPages: 1),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: MovieListScreen(
            args: MovieListArgs(
              title: 'Now Playing',
              type: MovieListType.nowPlaying,
              showReleaseDate: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MovieGridItem), findsNWidgets(2));
    expect(find.byType(MovieListRowItem), findsNothing);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();

    expect(find.byType(MovieGridItem), findsNothing);
    expect(find.byType(MovieListRowItem), findsNWidgets(2));
  });

  testWidgets('selecting a genre chip filters the visible movies', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      Right(
        PaginatedMovies(
          movies: [
            _movie(1, genreIds: [28]),
            _movie(2, genreIds: [35]),
          ],
          page: 1,
          totalPages: 1,
        ),
      ),
      null,
      const Right([
        Genre(id: 28, name: 'Action'),
        Genre(id: 35, name: 'Comedy'),
      ]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: MovieListScreen(
            args: MovieListArgs(
              title: 'Now Playing',
              type: MovieListType.nowPlaying,
              showReleaseDate: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MovieGridItem), findsNWidgets(2));

    await tester.tap(find.text('Action'));
    await tester.pumpAndSettle();

    expect(find.byType(MovieGridItem), findsNWidgets(1));
  });
}
