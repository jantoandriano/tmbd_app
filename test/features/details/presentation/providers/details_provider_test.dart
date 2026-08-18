import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/details/presentation/providers/details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  late MockDetailsRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockDetailsRepository();
    container = ProviderContainer(
      overrides: [detailsRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('surfaces the repository result as data', () async {
    when(() => repository.getMovieDetails(movieId: 550)).thenAnswer(
      (_) async => const Right(
        MovieDetails(
          id: 550,
          title: 'Fight Club',
          overview: 'overview',
          voteAverage: 8.4,
        ),
      ),
    );

    final details = await container.read(
      movieDetailsProvider(movieId: 550).future,
    );

    expect(details.title, 'Fight Club');
  });

  test('surfaces a repository failure as an AsyncError', () async {
    when(
      () => repository.getMovieDetails(movieId: 550),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    container.listen(movieDetailsProvider(movieId: 550), (_, _) {});
    await container.pump();

    final state = container.read(movieDetailsProvider(movieId: 550));
    expect(state.hasError, isTrue);
    expect(state.error, isA<Failure>());
  });
}
