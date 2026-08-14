import 'dart:async';

import 'package:cinetrack/core/router/app_router.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../helpers/fake_discover_repository.dart';

void main() {
  testWidgets('/ shows Discover and pushing /movie/:id shows the placeholder', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);

    unawaited(appRouter.push('/movie/42'));
    await tester.pumpAndSettle();

    expect(find.text('Movie 42'), findsOneWidget);
  });
}
