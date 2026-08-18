import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:cinetrack/features/details/data/repositories/details_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDetailsRemoteDataSource extends Mock
    implements DetailsRemoteDataSource {}

void main() {
  late MockDetailsRemoteDataSource dataSource;
  late DetailsRepositoryImpl repository;

  setUp(() {
    dataSource = MockDetailsRemoteDataSource();
    repository = DetailsRepositoryImpl(dataSource);
  });

  test('returns Right(MovieDetails) on success', () async {
    when(() => dataSource.fetchMovieDetails(movieId: 550)).thenAnswer(
      (_) async => const MovieDetailsModel(
        id: 550,
        title: 'Fight Club',
        overview: 'overview',
        voteAverage: 8.4,
      ),
    );

    final result = await repository.getMovieDetails(movieId: 550);

    expect(result.isRight(), isTrue);
    result.match(
      (l) => fail('expected Right, got Left($l)'),
      (r) => expect(r.title, 'Fight Club'),
    );
  });

  test(
    'returns Left(ServerFailure) when DioException carries a response',
    () async {
      when(() => dataSource.fetchMovieDetails(movieId: 550)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/movie/550'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/movie/550'),
          ),
        ),
      );

      final result = await repository.getMovieDetails(movieId: 550);

      expect(result.isLeft(), isTrue);
      result.match(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    },
  );

  test(
    'returns Left(NetworkFailure) when DioException has no response',
    () async {
      when(() => dataSource.fetchMovieDetails(movieId: 550)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/movie/550')),
      );

      final result = await repository.getMovieDetails(movieId: 550);

      result.match(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    },
  );

  test('returns Left(UnexpectedFailure) on a non-Dio exception', () async {
    when(
      () => dataSource.fetchMovieDetails(movieId: 550),
    ).thenThrow(Exception('boom'));

    final result = await repository.getMovieDetails(movieId: 550);

    result.match(
      (l) => expect(l, isA<UnexpectedFailure>()),
      (r) => fail('expected Left, got Right($r)'),
    );
  });
}
