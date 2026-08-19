import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_provider.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_service_provider.dart';
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAiOverviewService extends Mock implements AiOverviewService {}

void main() {
  const movie = MovieDetails(
    id: 550,
    title: 'Fight Club',
    overview: 'overview',
    voteAverage: 8.4,
  );

  late MockAiOverviewService service;
  late ProviderContainer container;

  setUp(() {
    service = MockAiOverviewService();
    container = ProviderContainer(
      overrides: [aiOverviewServiceProvider.overrideWithValue(service)],
    );
  });

  tearDown(() => container.dispose());

  test('surfaces the service summary as data', () async {
    when(
      () => service.summarize(movie: movie),
    ).thenAnswer((_) async => 'a generated summary');

    final summary = await container.read(
      aiOverviewSummaryProvider(movie: movie).future,
    );

    expect(summary, 'a generated summary');
  });
}
