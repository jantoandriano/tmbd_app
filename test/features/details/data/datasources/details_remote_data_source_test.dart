import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DetailsRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = DetailsRemoteDataSourceImpl(dio);
  });

  test(
    'fetchMovieDetails requests append_to_response=credits,videos '
    'and decodes the response',
    () async {
      final json = <String, dynamic>{
        'id': 550,
        'title': 'Fight Club',
        'overview': 'overview',
        'vote_average': 8.4,
        'genres': <Map<String, dynamic>>[],
      };

      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/550',
          queryParameters: {'append_to_response': 'credits,videos'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: json,
          requestOptions: RequestOptions(path: '/movie/550'),
        ),
      );

      final result = await dataSource.fetchMovieDetails(movieId: 550);

      expect(result, isA<MovieDetailsModel>());
      expect(result.id, 550);
      expect(result.title, 'Fight Club');
    },
  );

  test('fetchMovieDetails lets DioException propagate', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        '/movie/550',
        queryParameters: {'append_to_response': 'credits,videos'},
      ),
    ).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/movie/550')),
    );

    expect(
      () => dataSource.fetchMovieDetails(movieId: 550),
      throwsA(isA<DioException>()),
    );
  });
}
