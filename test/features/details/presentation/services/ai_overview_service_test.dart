import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _geminiResponse(String text) => Response(
  data: {
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': text},
          ],
        },
      },
    ],
  },
  requestOptions: RequestOptions(path: 'models/gemini-2.0-flash'),
);

void main() {
  const movie = MovieDetails(
    id: 550,
    title: 'Fight Club',
    overview: 'An insomniac and a soap salesman start a fight club.',
    voteAverage: 8.4,
    genres: ['Drama', 'Thriller'],
  );

  late MockDio dio;
  late GeminiOverviewService service;

  setUp(() {
    dio = MockDio();
    service = GeminiOverviewService(dio);
    registerFallbackValue(<String, dynamic>{});
  });

  group('summarize', () {
    test('returns the generated text from the response', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => _geminiResponse('a fresh AI summary'));

      final summary = await service.summarize(movie: movie);

      expect(summary, 'a fresh AI summary');
    });

    test('falls back to the TMDB overview on failure', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: 'x')),
      );

      final summary = await service.summarize(movie: movie);

      expect(summary, movie.overview);
    });
  });

  group('answer', () {
    test('returns the generated text from the response', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => _geminiResponse('a grounded answer'));

      final answer = await service.answer(
        movie: movie,
        question: 'Who directed this?',
        history: const [],
      );

      expect(answer, 'a grounded answer');
    });

    test('sends prior turns as alternating user/model contents', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => _geminiResponse('follow-up answer'));

      await service.answer(
        movie: movie,
        question: 'What about a sequel?',
        history: const [(question: 'Who directed this?', answer: 'unknown')],
      );

      final captured = verify(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: captureAny(named: 'data'),
        ),
      ).captured.single as Map<String, dynamic>;
      final contents = captured['contents'] as List<dynamic>;

      expect(contents, hasLength(3));
      expect((contents[0] as Map)['role'], 'user');
      expect((contents[1] as Map)['role'], 'model');
      expect((contents[2] as Map)['role'], 'user');
    });

    test('falls back to a friendly message on failure', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: 'x')),
      );

      final answer = await service.answer(
        movie: movie,
        question: 'Who directed this?',
        history: const [],
      );

      expect(answer, contains('unavailable'));
    });
  });
}
