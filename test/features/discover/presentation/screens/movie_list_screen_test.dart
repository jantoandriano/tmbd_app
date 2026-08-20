import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_provider.dart';
import 'package:cinetrack/features/discover/presentation/screens/movie_list_screen.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_discover_repository.dart';

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  voteAverage: 7,
  releaseDate: '2024-01-01',
  overview: 'overview',
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
}
