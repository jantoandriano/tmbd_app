import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';

class FakeDetailsRepository implements DetailsRepository {
  FakeDetailsRepository(this.result);

  final Result<MovieDetails> result;

  @override
  Future<Result<MovieDetails>> getMovieDetails({
    required int movieId,
  }) async => result;
}
