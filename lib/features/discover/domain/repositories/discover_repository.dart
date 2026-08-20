import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/genre.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';

abstract class DiscoverRepository {
  Future<Result<PaginatedMovies>> getNowPlayingMovies({required int page});

  Future<Result<PaginatedMovies>> getUpcomingMovies({required int page});

  Future<Result<List<Genre>>> getGenres();
}
