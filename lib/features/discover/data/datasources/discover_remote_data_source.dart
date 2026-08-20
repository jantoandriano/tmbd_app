import 'package:cinetrack/features/discover/data/models/genre_list_response_model.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:dio/dio.dart';

abstract class DiscoverRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MoviePageResponseModel> fetchNowPlayingMovies({required int page});

  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MoviePageResponseModel> fetchUpcomingMovies({required int page});

  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<GenreListResponseModel> fetchGenres();
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  DiscoverRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MoviePageResponseModel> fetchNowPlayingMovies({
    required int page,
  }) => _fetch('/movie/now_playing', page: page);

  @override
  Future<MoviePageResponseModel> fetchUpcomingMovies({required int page}) =>
      _fetch('/movie/upcoming', page: page);

  @override
  Future<GenreListResponseModel> fetchGenres() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/genre/movie/list',
    );
    return GenreListResponseModel.fromJson(response.data!);
  }

  Future<MoviePageResponseModel> _fetch(
    String path, {
    required int page,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: {'page': page},
    );
    return MoviePageResponseModel.fromJson(response.data!);
  }
}
