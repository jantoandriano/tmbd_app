import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DiscoverRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = DiscoverRemoteDataSourceImpl(dio);
  });

  final json = <String, dynamic>{
    'page': 1,
    'results': <Map<String, dynamic>>[],
    'total_pages': 500,
    'total_results': 10000,
  };

  group('fetchNowPlayingMovies', () {
    test('decodes the response into MoviePageResponseModel', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/now_playing',
          queryParameters: {'page': 1},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: json,
          requestOptions: RequestOptions(path: '/movie/now_playing'),
        ),
      );

      final result = await dataSource.fetchNowPlayingMovies(page: 1);

      expect(result, isA<MoviePageResponseModel>());
      expect(result.page, 1);
      expect(result.totalPages, 500);
    });

    test('lets DioException propagate', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/now_playing',
          queryParameters: {'page': 1},
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/movie/now_playing')),
      );

      expect(
        () => dataSource.fetchNowPlayingMovies(page: 1),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('fetchUpcomingMovies', () {
    test('decodes the response into MoviePageResponseModel', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/upcoming',
          queryParameters: {'page': 1},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: json,
          requestOptions: RequestOptions(path: '/movie/upcoming'),
        ),
      );

      final result = await dataSource.fetchUpcomingMovies(page: 1);

      expect(result, isA<MoviePageResponseModel>());
      expect(result.page, 1);
      expect(result.totalPages, 500);
    });

    test('lets DioException propagate', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/upcoming',
          queryParameters: {'page': 1},
        ),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/movie/upcoming')),
      );

      expect(
        () => dataSource.fetchUpcomingMovies(page: 1),
        throwsA(isA<DioException>()),
      );
    });
  });
}
