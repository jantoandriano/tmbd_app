import 'dart:async';

import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_provider.g.dart';

@Riverpod(keepAlive: true)
class DiscoverNotifier extends _$DiscoverNotifier {
  @override
  Future<DiscoverState> build() async {
    final repository = ref.watch(discoverRepositoryProvider);
    final results = await (
      repository.getNowPlayingMovies(page: 1),
      repository.getUpcomingMovies(page: 1),
    ).wait;

    final nowPlaying = results.$1.match(
      (failure) => throw failure,
      (paginated) => paginated.movies,
    );
    final comingSoon = results.$2.match(
      (failure) => throw failure,
      (paginated) => paginated.movies,
    );

    return DiscoverState(nowPlaying: nowPlaying, comingSoon: comingSoon);
  }
}
