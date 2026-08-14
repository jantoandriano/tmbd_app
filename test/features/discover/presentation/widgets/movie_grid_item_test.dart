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
    body: SizedBox(width: 200, height: 300, child: child),
  ),
);

void main() {
  testWidgets('shows a placeholder icon when posterPath is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      _boundedHome(MovieGridItem(movie: _movie(), onTap: () {})),
    );

    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    expect(find.text('Fight Club'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _boundedHome(MovieGridItem(movie: _movie(), onTap: () => tapped = true)),
    );
    await tester.tap(find.byType(MovieGridItem));

    expect(tapped, isTrue);
  });
}
