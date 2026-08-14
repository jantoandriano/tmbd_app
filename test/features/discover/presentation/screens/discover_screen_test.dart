import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/screens/discover_screen.dart';
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
  testWidgets('shows the movie grid when data loads', (tester) async {
    final repository = FakeDiscoverRepository(
      Right(
        PaginatedMovies(
          movies: [_movie(1), _movie(2)],
          page: 1,
          totalPages: 5,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MovieGridItem), findsNWidgets(2));
  });

  testWidgets('shows an error state with a retry button on failure', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      const Left(Failure.network('offline')),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });
}
