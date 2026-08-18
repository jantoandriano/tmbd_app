import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:dio/dio.dart';

// Deliberate clean-architecture pattern: a single-method interface for
// dependency inversion and mockability, not a smell.
// ignore: one_member_abstracts
abstract class DetailsRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MovieDetailsModel> fetchMovieDetails({required int movieId});
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  DetailsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MovieDetailsModel> fetchMovieDetails({required int movieId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/$movieId',
      queryParameters: {'append_to_response': 'credits,videos'},
    );
    return MovieDetailsModel.fromJson(response.data!);
  }
}
