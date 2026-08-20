import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_list_provider.g.dart';

enum MovieListType { nowPlaying, comingSoon }

@riverpod
class MovieListNotifier extends _$MovieListNotifier {
  @override
  Future<MovieListState> build(MovieListType type) async {
    final repository = ref.watch(discoverRepositoryProvider);
    final result = await _fetch(repository, page: 1);
    return result.match(
      (failure) => throw failure,
      (paginated) => MovieListState(
        movies: paginated.movies,
        page: paginated.page,
        totalPages: paginated.totalPages,
      ),
    );
  }

  Future<Result<PaginatedMovies>> _fetch(
    DiscoverRepository repository, {
    required int page,
  }) {
    return type == MovieListType.nowPlaying
        ? repository.getNowPlayingMovies(page: page)
        : repository.getUpcomingMovies(page: page);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore) return;
    if (current.page >= current.totalPages) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final repository = ref.read(discoverRepositoryProvider);
    final result = await _fetch(repository, page: current.page + 1);

    result.match(
      (failure) => state = AsyncData(current.copyWith(isLoadingMore: false)),
      (paginated) => state = AsyncData(
        current.copyWith(
          movies: [...current.movies, ...paginated.movies],
          page: paginated.page,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
