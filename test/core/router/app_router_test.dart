import 'dart:async';

import 'package:cinetrack/core/router/app_router.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../helpers/fake_details_repository.dart';
import '../../helpers/fake_discover_repository.dart';

void main() {
  testWidgets(
    '/ shows Discover and pushing /movie/:id shows the details screen',
    (tester) async {
      final discoverRepository = FakeDiscoverRepository(
        const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
      );
      final detailsRepository = FakeDetailsRepository(
        const Right(
          MovieDetails(
            id: 42,
            title: 'Movie 42',
            overview: 'overview',
            voteAverage: 7,
          ),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            discoverRepositoryProvider.overrideWithValue(discoverRepository),
            detailsRepositoryProvider.overrideWithValue(detailsRepository),
          ],
          child: MaterialApp.router(routerConfig: appRouter),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Discover'), findsOneWidget);

      unawaited(appRouter.push('/movie/42'));
      await tester.pumpAndSettle();

      expect(find.text('Movie 42'), findsOneWidget);
    },
  );
}
