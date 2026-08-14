import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';

class FakeDiscoverRepository implements DiscoverRepository {
  FakeDiscoverRepository(this.result);

  final Result<PaginatedMovies> result;

  @override
  Future<Result<PaginatedMovies>> getPopularMovies({
    required int page,
  }) async => result;
}
