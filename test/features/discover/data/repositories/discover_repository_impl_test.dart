import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:cinetrack/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoverRemoteDataSource extends Mock
    implements DiscoverRemoteDataSource {}

void main() {
  late MockDiscoverRemoteDataSource dataSource;
  late DiscoverRepositoryImpl repository;

  setUp(() {
    dataSource = MockDiscoverRemoteDataSource();
    repository = DiscoverRepositoryImpl(dataSource);
  });

  group('getNowPlayingMovies', () {
    test('returns Right(PaginatedMovies) on success', () async {
      when(() => dataSource.fetchNowPlayingMovies(page: 1)).thenAnswer(
        (_) async => const MoviePageResponseModel(
          page: 1,
          results: [],
          totalPages: 500,
        ),
      );

      final result = await repository.getNowPlayingMovies(page: 1);

      expect(result.isRight(), isTrue);
      result.match(
        (l) => fail('expected Right, got Left($l)'),
        (r) {
          expect(r.page, 1);
          expect(r.totalPages, 500);
        },
      );
    });

    test(
      'returns Left(ServerFailure) when DioException carries a response',
      () async {
        when(() => dataSource.fetchNowPlayingMovies(page: 1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/movie/now_playing'),
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: '/movie/now_playing'),
            ),
          ),
        );

        final result = await repository.getNowPlayingMovies(page: 1);

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
        when(() => dataSource.fetchNowPlayingMovies(page: 1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/movie/now_playing'),
          ),
        );

        final result = await repository.getNowPlayingMovies(page: 1);

        result.match(
          (l) => expect(l, isA<NetworkFailure>()),
          (r) => fail('expected Left, got Right($r)'),
        );
      },
    );

    test('returns Left(UnexpectedFailure) on a non-Dio exception', () async {
      when(
        () => dataSource.fetchNowPlayingMovies(page: 1),
      ).thenThrow(Exception('boom'));

      final result = await repository.getNowPlayingMovies(page: 1);

      result.match(
        (l) => expect(l, isA<UnexpectedFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    });
  });

  group('getUpcomingMovies', () {
    test('returns Right(PaginatedMovies) on success', () async {
      when(() => dataSource.fetchUpcomingMovies(page: 1)).thenAnswer(
        (_) async => const MoviePageResponseModel(
          page: 1,
          results: [],
          totalPages: 300,
        ),
      );

      final result = await repository.getUpcomingMovies(page: 1);

      expect(result.isRight(), isTrue);
      result.match(
        (l) => fail('expected Right, got Left($l)'),
        (r) {
          expect(r.page, 1);
          expect(r.totalPages, 300);
        },
      );
    });

    test(
      'returns Left(ServerFailure) when DioException carries a response',
      () async {
        when(() => dataSource.fetchUpcomingMovies(page: 1)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/movie/upcoming'),
            response: Response(
              statusCode: 401,
              requestOptions: RequestOptions(path: '/movie/upcoming'),
            ),
          ),
        );

        final result = await repository.getUpcomingMovies(page: 1);

        expect(result.isLeft(), isTrue);
        result.match(
          (l) => expect(l, isA<ServerFailure>()),
          (r) => fail('expected Left, got Right($r)'),
        );
      },
    );
  });
}
