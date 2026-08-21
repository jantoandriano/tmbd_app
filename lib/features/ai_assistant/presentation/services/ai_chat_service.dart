import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:dio/dio.dart';

/// Chat swap-point: answers free-text movie questions and recommends
/// CineTrack catalog titles. Backed by [GeminiChatService]; test doubles
/// implement this interface directly.
abstract class AiChatService {
  Future<({String text, List<Movie> recommendations})> respond({
    required String question,
    required List<({String role, String content})> history,
    required List<Movie> catalog,
  });
}

const _unavailableReply =
    'AI is unavailable right now — try again in a moment.';

class GeminiChatService implements AiChatService {
  GeminiChatService(this._dio);

  final Dio _dio;

  @override
  Future<({String text, List<Movie> recommendations})> respond({
    required String question,
    required List<({String role, String content})> history,
    required List<Movie> catalog,
  }) async {
    try {
      final contents = <Map<String, Object?>>[
        for (final turn in history) _turnContent(turn.role, turn.content),
        _turnContent('user', question),
      ];
      final text = await _generate(
        systemInstruction: _systemPrompt(catalog),
        contents: contents,
      );
      if (text == null) {
        return (text: _unavailableReply, recommendations: const <Movie>[]);
      }
      return _parseReply(text, catalog);
    } on Object {
      return (text: _unavailableReply, recommendations: const <Movie>[]);
    }
  }

  ({String text, List<Movie> recommendations}) _parseReply(
    String raw,
    List<Movie> catalog,
  ) {
    final lines = raw.split('\n');
    final recIndex = lines.indexWhere(
      (line) => line.trimLeft().startsWith('RECOMMEND:'),
    );
    if (recIndex == -1) {
      return (text: raw.trim(), recommendations: const <Movie>[]);
    }

    final ids = lines[recIndex]
        .split('RECOMMEND:')
        .last
        .split(',')
        .map((id) => int.tryParse(id.trim()))
        .whereType<int>()
        .toSet();
    final recommendations = catalog
        .where((movie) => ids.contains(movie.id))
        .toList();

    final remaining = List<String>.from(lines)..removeAt(recIndex);
    return (
      text: remaining.join('\n').trim(),
      recommendations: recommendations,
    );
  }

  Future<String?> _generate({
    required String systemInstruction,
    required List<Map<String, Object?>> contents,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/${ApiConstants.geminiModel}:generateContent',
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

  Map<String, Object?> _turnContent(String role, String text) => {
    'role': role,
    'parts': [
      {'text': text},
    ],
  };

  String _systemPrompt(List<Movie> catalog) {
    final listing = catalog
        .map((movie) => '- ${movie.title} (id: ${movie.id})')
        .join('\n');
    return 'You are the CineTrack movie assistant. You can discuss any '
        'movie and recommend titles. Here is the current CineTrack catalog '
        'the user can add straight to their watchlist:\n$listing\n\n'
        'When your answer recommends one or more of these catalog titles, '
        'end your reply with a final line formatted exactly as '
        '"RECOMMEND: id1,id2" using their ids above, and nothing else on '
        'that line. Only reference ids from the catalog. Omit that line '
        "entirely if you aren't recommending a specific catalog title. "
        'Keep the main reply under 80 words. No markdown.';
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
