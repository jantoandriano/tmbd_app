import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';

class FakeDiscoverRepository implements DiscoverRepository {
  FakeDiscoverRepository(
    this.nowPlayingResult, [
    Result<PaginatedMovies>? upcomingResult,
  ]) : upcomingResult = upcomingResult ?? nowPlayingResult;

  final Result<PaginatedMovies> nowPlayingResult;
  final Result<PaginatedMovies> upcomingResult;

  @override
  Future<Result<PaginatedMovies>> getNowPlayingMovies({
    required int page,
  }) async => nowPlayingResult;

  @override
  Future<Result<PaginatedMovies>> getUpcomingMovies({
    required int page,
  }) async => upcomingResult;
}
