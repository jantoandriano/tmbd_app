import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/details/presentation/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_details_repository.dart';

const _movie = MovieDetails(
  id: 550,
  title: 'Fight Club',
  overview:
      'An insomniac office worker and a soap salesman build a global '
      'organization.',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
  runtimeMinutes: 139,
  genres: ['Drama', 'Thriller'],
  cast: [
    CastMember(id: 1, name: 'Edward Norton', character: 'The Narrator'),
  ],
);

Widget _wrap(Widget child, {required Result<MovieDetails> result}) =>
    ProviderScope(
      overrides: [
        detailsRepositoryProvider.overrideWithValue(
          FakeDetailsRepository(result),
        ),
      ],
      child: MaterialApp(home: child),
    );

void main() {
  testWidgets('shows a loading indicator while fetching', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an error state with a retry button on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Left(Failure.network('offline')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });

  testWidgets('shows title, meta, genres, and cast when loaded', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fight Club'), findsOneWidget);
    expect(find.textContaining('8.4'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('Thriller'), findsOneWidget);
    expect(find.text('Edward Norton'), findsOneWidget);
    expect(find.text('The Narrator'), findsOneWidget);
  });

  testWidgets('toggles the watchlist button label on tap', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to Watchlist'), findsOneWidget);

    await tester.ensureVisible(find.text('Add to Watchlist'));
    await tester.tap(find.text('Add to Watchlist'));
    await tester.pump();

    expect(find.text('In Watchlist'), findsOneWidget);
  });

  testWidgets('shows a snackbar when there is no trailer', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Trailer'));
    await tester.tap(find.text('Trailer'));
    await tester.pump();

    expect(find.text('No trailer available'), findsOneWidget);
  });

  testWidgets('tapping a suggested chip appends a Q&A turn', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Who directed this?'), findsWidgets);

    await tester.ensureVisible(find.text('Who directed this?').last);
    await tester.tap(find.text('Who directed this?').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Fight Club'), findsWidgets);
  });

  testWidgets('submitting a typed question appends a Q&A turn', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Right(_movie),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(
      find.byType(TextField),
      'What is the meaning of life?',
    );
    await tester.ensureVisible(find.byIcon(Icons.send));
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('What is the meaning of life?'), findsOneWidget);
    expect(find.textContaining('suggested questions'), findsOneWidget);
  });
}
