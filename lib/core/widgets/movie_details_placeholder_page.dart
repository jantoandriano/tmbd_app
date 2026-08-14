import 'package:flutter/material.dart';

/// Placeholder for the real movie details screen (a future feature).
/// Proves route + path-parameter passing from the discover grid.
class MovieDetailsPlaceholderPage extends StatelessWidget {
  const MovieDetailsPlaceholderPage({required this.movieId, super.key});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Movie $movieId')),
    );
  }
}
