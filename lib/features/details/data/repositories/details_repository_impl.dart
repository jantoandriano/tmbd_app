import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  DetailsRepositoryImpl(this._remoteDataSource);

  final DetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<MovieDetails>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      final response = await _remoteDataSource.fetchMovieDetails(
        movieId: movieId,
      );
      return Right(response.toEntity());
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
