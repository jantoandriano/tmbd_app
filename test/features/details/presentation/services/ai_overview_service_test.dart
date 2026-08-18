import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const movie = MovieDetails(
    id: 550,
    title: 'Fight Club',
    overview: 'overview',
    voteAverage: 8.4,
    genres: ['Drama', 'Thriller'],
  );

  late AiOverviewService service;

  setUp(() => service = AiOverviewService());

  test('answers a director question', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'Who directed this?',
    );

    expect(answer, contains('Fight Club'));
  });

  test('answers a similar-movies question using the genres', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'Similar movies',
    );

    expect(answer, contains('Drama/Thriller'));
  });

  test('answers a content-warnings question case-insensitively', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'CONTENT WARNINGS?',
    );

    expect(answer, contains('Fight Club'));
  });

  test('falls back to a generic answer for anything else', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'What is the meaning of life?',
    );

    expect(answer, contains('suggested questions'));
  });
}
