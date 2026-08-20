import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:cinetrack/features/discover/domain/entities/genre.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  DiscoverRepositoryImpl(this._remoteDataSource);

  final DiscoverRemoteDataSource _remoteDataSource;

  @override
  Future<Result<PaginatedMovies>> getNowPlayingMovies({required int page}) =>
      _getMovies(() => _remoteDataSource.fetchNowPlayingMovies(page: page));

  @override
  Future<Result<PaginatedMovies>> getUpcomingMovies({required int page}) =>
      _getMovies(() => _remoteDataSource.fetchUpcomingMovies(page: page));

  @override
  Future<Result<List<Genre>>> getGenres() => _run(() async {
    final response = await _remoteDataSource.fetchGenres();
    return response.genres.map((g) => g.toEntity()).toList();
  });

  Future<Result<PaginatedMovies>> _getMovies(
    Future<MoviePageResponseModel> Function() fetch,
  ) => _run(() async {
    final response = await fetch();
    return PaginatedMovies(
      movies: response.results.map((m) => m.toEntity()).toList(),
      page: response.page,
      totalPages: response.totalPages,
    );
  });

  Future<Result<T>> _run<T>(Future<T> Function() fetch) async {
    try {
      return Right(await fetch());
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        return Left(
          Failure.server(
            e.message ?? 'Server error',
            statusCode: response.statusCode,
          ),
        );
      }
      return Left(Failure.network(e.message ?? 'Network error'));
      // Deliberate catch-all: anything not a DioException (JSON decode
      // errors, etc.) still needs to become a Failure, not propagate.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
