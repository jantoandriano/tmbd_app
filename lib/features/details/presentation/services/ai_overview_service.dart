import 'package:cinetrack/features/details/domain/entities/movie_details.dart';

/// Local, network-free mock for the AI Overview panel's Q&A. Deliberately
/// simple keyword matching — the point is the interaction shape (a growing
/// thread with a pending state), not answer quality. Swapping in a real
/// backend later only touches this class.
class AiOverviewService {
  Future<String> answer({
    required MovieDetails movie,
    required String question,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final q = question.toLowerCase();

    if (q.contains('direct')) {
      return "Director credits aren't in this app's data yet — check TMDB "
          "for ${movie.title}'s full crew listing.";
    }
    if (q.contains('similar')) {
      final genres = movie.genres.isEmpty
          ? 'this genre'
          : movie.genres.join('/');
      return 'Movies with a similar $genres feel are a good next watch — '
          "recommendations aren't wired up yet, but that's the vibe.";
    }
    if (q.contains('warning') || q.contains('content')) {
      return 'No structured content-warning data is available for '
          '${movie.title} yet — check a parental-guide site before '
          'watching with sensitive viewers.';
    }
    return "That's outside what this mock AI Overview can answer yet — "
        'try one of the suggested questions above.';
  }
}
