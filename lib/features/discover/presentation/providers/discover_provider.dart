import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_provider.g.dart';

@Riverpod(keepAlive: true)
class DiscoverNotifier extends _$DiscoverNotifier {
  @override
  Future<DiscoverState> build() async {
    final repository = ref.watch(discoverRepositoryProvider);
    final result = await repository.getPopularMovies(page: 1);

    return result.match(
      (failure) => throw failure,
      (paginated) => DiscoverState(
        movies: paginated.movies,
        page: paginated.page,
        hasReachedMax: paginated.page >= paginated.totalPages,
      ),
    );
  }

  Future<Failure?> loadNextPage() async {
    final current = state.value;
    if (current == null || current.hasReachedMax || current.isLoadingMore) {
      return null;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final repository = ref.read(discoverRepositoryProvider);
    final nextPage = current.page + 1;
    final result = await repository.getPopularMovies(page: nextPage);

    return result.match<Failure?>(
      (failure) {
        state = AsyncData(current.copyWith(isLoadingMore: false));
        return failure;
      },
      (paginated) {
        state = AsyncData(
          current.copyWith(
            movies: [...current.movies, ...paginated.movies],
            page: nextPage,
            hasReachedMax: nextPage >= paginated.totalPages,
            isLoadingMore: false,
          ),
        );
        return null;
      },
    );
  }
}
