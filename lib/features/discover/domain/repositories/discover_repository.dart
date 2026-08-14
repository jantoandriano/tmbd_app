import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';

// Deliberate clean-architecture pattern: a single-method interface for
// dependency inversion and mockability, not a smell.
// ignore: one_member_abstracts
abstract class DiscoverRepository {
  Future<Result<PaginatedMovies>> getPopularMovies({required int page});
}
