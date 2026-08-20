import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'genre_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Map<int, String>> genreMap(Ref ref) async {
  final repository = ref.watch(discoverRepositoryProvider);
  final result = await repository.getGenres();
  return result.match(
    (failure) => <int, String>{},
    (genres) => {for (final genre in genres) genre.id: genre.name},
  );
}
