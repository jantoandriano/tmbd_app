import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';

// Deliberate clean-architecture pattern: a single-method interface for
// dependency inversion and mockability, not a smell.
// ignore: one_member_abstracts
abstract class DetailsRepository {
  Future<Result<MovieDetails>> getMovieDetails({required int movieId});
}
