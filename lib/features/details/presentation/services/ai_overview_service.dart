import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:dio/dio.dart';

/// AI Overview swap-point: summarizes a movie and answers free-text
/// questions about it. Backed by [GeminiOverviewService]; test doubles
/// implement this interface directly.
abstract class AiOverviewService {
  Future<String> summarize({required MovieDetails movie});

  Future<String> answer({
    required MovieDetails movie,
    required String question,
    required List<({String question, String answer})> history,
  });
}

const _unavailableAnswer =
    'AI is unavailable right now — try again in a moment.';

class GeminiOverviewService implements AiOverviewService {
  GeminiOverviewService(this._dio);

  final Dio _dio;

  @override
  Future<String> summarize({required MovieDetails movie}) async {
    try {
      final text = await _generate(
        systemInstruction: _movieFactsPrompt(movie),
        contents: [
          _userContent(
            'Write a 2-3 sentence engaging overview of this movie for an '
            "app screen. Don't repeat the title as a heading. No markdown.",
          ),
        ],
      );
      return text ?? movie.overview;
    } on Object {
      return movie.overview;
    }
  }

  @override
  Future<String> answer({
    required MovieDetails movie,
    required String question,
    required List<({String question, String answer})> history,
  }) async {
    try {
      final contents = <Map<String, Object?>>[
        for (final turn in history) ...[
          _userContent(turn.question),
          _modelContent(turn.answer),
        ],
        _userContent(question),
      ];
      final text = await _generate(
        systemInstruction:
            '${_movieFactsPrompt(movie)}\n\n'
            'Answer the question using only the facts above. If the facts '
            "don't cover it, say so plainly. Keep the answer under 60 words. "
            'No markdown.',
        contents: contents,
      );
      return text ?? _unavailableAnswer;
    } on Object {
      return _unavailableAnswer;
    }
  }

  Future<String?> _generate({
    required String systemInstruction,
    required List<Map<String, Object?>> contents,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConstants.geminiModel}:generateContent',
      data: {
        'system_instruction': {
          'parts': [
            {'text': systemInstruction},
          ],
        },
        'contents': contents,
      },
    );

    final candidates = response.data?['candidates'] as List<dynamic>?;
    final parts =
        (candidates?.firstOrNull as Map<String, dynamic>?)?['content']
            as Map<String, dynamic>?;
    final text =
        ((parts?['parts'] as List<dynamic>?)?.firstOrNull
                as Map<String, dynamic>?)?['text']
            as String?;
    return text?.trim();
  }

  Map<String, Object?> _userContent(String text) => {
    'role': 'user',
    'parts': [
      {'text': text},
    ],
  };

  Map<String, Object?> _modelContent(String text) => {
    'role': 'model',
    'parts': [
      {'text': text},
    ],
  };

  String _movieFactsPrompt(MovieDetails movie) {
    final facts = <String>[
      'Title: ${movie.title}',
      if (movie.releaseDate != null) 'Release date: ${movie.releaseDate}',
      if (movie.genres.isNotEmpty) 'Genres: ${movie.genres.join(', ')}',
      'Rating: ${movie.voteAverage}/10',
      if (movie.cast.isNotEmpty)
        'Cast: ${movie.cast.take(5).map((c) => c.name).join(', ')}',
      'TMDB overview: ${movie.overview}',
    ];
    return 'You are a movie assistant inside the CineTrack app. Facts about '
        'the movie:\n${facts.join('\n')}';
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
