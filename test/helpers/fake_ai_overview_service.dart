import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';

class FakeAiOverviewService implements AiOverviewService {
  @override
  Future<String> summarize({required MovieDetails movie}) async =>
      'AI summary of ${movie.title}';

  @override
  Future<String> answer({
    required MovieDetails movie,
    required String question,
    required List<({String question, String answer})> history,
  }) async => 'AI answer to $question';
}
