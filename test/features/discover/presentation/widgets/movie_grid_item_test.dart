import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Movie _movie({String? posterPath}) => Movie(
  id: 1,
  title: 'Fight Club',
  posterPath: posterPath,
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
  overview: 'overview',
);

Widget _boundedHome(Widget child) => MaterialApp(
  home: Scaffold(
    body: SizedBox(
      height: 300,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

void main() {
  testWidgets('shows a placeholder icon when posterPath is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      _boundedHome(
        MovieGridItem(movie: _movie(), showReleaseDate: false, onTap: () {}),
      ),
    );

    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    expect(find.text('Fight Club'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _boundedHome(
        MovieGridItem(
          movie: _movie(),
          showReleaseDate: false,
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.tap(find.byType(MovieGridItem));

    expect(tapped, isTrue);
  });
}
