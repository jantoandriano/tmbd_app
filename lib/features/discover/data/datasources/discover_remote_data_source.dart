import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:dio/dio.dart';

// Deliberate clean-architecture pattern: a single-method interface for
// dependency inversion and mockability, not a smell.
// ignore: one_member_abstracts
abstract class DiscoverRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MoviePageResponseModel> fetchPopularMovies({required int page});
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  DiscoverRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MoviePageResponseModel> fetchPopularMovies({
    required int page,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return MoviePageResponseModel.fromJson(response.data!);
  }
}
