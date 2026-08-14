# Discover Feature Design

**Goal:** Build the Discover feature — a paginated grid of TMDB's popular movies, infinite-scrolling, becomes the app's home screen. First real feature built on the CineTrack scaffold; establishes the data/domain/presentation pattern later features (search, details, auth, watchlist) will follow.

**Scope:** Movies only. TMDB `/movie/popular`, no filters/sort in this pass. Tapping a poster navigates to a placeholder `/movie/:id` route (real details screen is a separate future feature).

## Global Constraints

- All imports use `package:cinetrack/...` — relative imports fail `very_good_analysis`'s `always_use_package_imports` lint (established in the scaffold pass).
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors; `flutter analyze` must report zero issues.
- Repository methods return `Result<T>` (`typedef Result<T> = Either<Failure, T>` from `core/utils/result.dart`), never throw past the data layer.
- No new top-level dependency beyond `cached_network_image` (added this pass) — everything else (dio, riverpod, freezed, json_serializable, get_it/injectable) is already in `pubspec.yaml` from the scaffold.
- `TMDB_API_KEY` is read once via `EnvConfig.tmdbApiKey` (throws `StateError` if missing — already enforced at `bootstrap()` time).

## Architecture

```
lib/features/discover/
  domain/
    entities/movie.dart
    repositories/discover_repository.dart
  data/
    models/movie_model.dart
    datasources/discover_remote_data_source.dart
    repositories/discover_repository_impl.dart
  presentation/
    providers/discover_provider.dart
    screens/discover_screen.dart
    widgets/movie_grid_item.dart
```

No usecase layer. A single "fetch a page of popular movies" operation has no orchestration logic worth abstracting — the notifier calls the repository directly. Add a usecase layer later only if a second feature needs to share logic across repositories.

## Core change: TMDB API key on every request

TMDB requires `api_key` as a query parameter on every call, regardless of user auth state — this is distinct from `AuthInterceptor` (which is scaffolded for a future *user* auth token and stays a no-op here). Rather than repeating the key in every datasource call, `DioClient.create()` sets it once as a default query parameter:

```dart
// lib/core/network/dio_client.dart — modified
static Dio create({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      queryParameters: {'api_key': EnvConfig.tmdbApiKey},
    ),
  );
  ...
}
```

This is the only change to existing `core/` code. Everything else below is new.

## Domain contracts

```dart
// domain/entities/movie.dart
@freezed
class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    String? posterPath,
    required double voteAverage,
    String? releaseDate,
    required String overview,
  }) = _Movie;
}

// domain/entities/paginated_movies.dart
@freezed
class PaginatedMovies with _$PaginatedMovies {
  const factory PaginatedMovies({
    required List<Movie> movies,
    required int page,
    required int totalPages,
  }) = _PaginatedMovies;
}

// domain/repositories/discover_repository.dart
abstract class DiscoverRepository {
  Future<Result<PaginatedMovies>> getPopularMovies({required int page});
}
```

`MovieModel` (data layer) mirrors `Movie` with `@JsonKey` mappings for TMDB's snake_case fields (`poster_path`, `vote_average`, `release_date`) and adds `Movie toEntity()`.

TMDB's `/movie/popular` response is `{page, results: [...], total_pages, total_results}` — a separate top-level `MoviePageResponseModel` (freezed + json_serializable, `data/models/movie_page_response_model.dart`) decodes this directly: `{required int page, required List<MovieModel> results, @JsonKey(name: 'total_pages') required int totalPages}`.

```dart
// data/datasources/discover_remote_data_source.dart
abstract class DiscoverRemoteDataSource {
  /// Throws [DioException] on failure — caller (the repository) is
  /// responsible for catching and converting to [Failure].
  Future<MoviePageResponseModel> fetchPopularMovies({required int page});
}
```

`DiscoverRepositoryImpl.getPopularMovies` calls this, catches `DioException`, and on success maps `MoviePageResponseModel` to the domain `PaginatedMovies` (each `MovieModel` via `.toEntity()`).

## Data flow

1. `DiscoverScreen` watches `discoverNotifierProvider` (an `AsyncNotifier<DiscoverState>`).
2. On first build, the notifier loads page 1 via `DiscoverRepository.getPopularMovies(page: 1)`.
3. `DiscoverRepositoryImpl` calls `DiscoverRemoteDataSource.fetchPopularMovies(page)`, which hits `GET /movie/popular?page={page}` and decodes the response into `List<MovieModel>` + `totalPages` via `json_serializable`.
4. On success, `MovieModel.toEntity()` maps to the domain `Movie`; repository returns `Right(PaginatedMovies(movies, page, totalPages))`.
5. On `DioException`, repository catches it and returns `Left(Failure.network(...))` or `Left(Failure.server(...))` depending on whether a response came back.
6. Notifier folds the `Result`: success appends to `DiscoverState.movies` and updates `page`/`hasReachedMax` (`page >= totalPages`); failure sets `AsyncValue.error` (first page) or pushes a one-off error event for the UI to show as a snackbar (later pages — see below).

## State shape

```dart
@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<Movie> movies,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = _DiscoverState;
}
```

The notifier is `AsyncNotifier<DiscoverState>`. `build()` calls the repository for page 1: `Left` propagates as a thrown exception (so `AsyncNotifier`'s own error handling turns it into `AsyncValue.error` automatically — the existing full-screen error+retry UI applies for free); `Right` returns the initial `DiscoverState`.

`Future<Failure?> loadNextPage()` — returns `null` on success, the `Failure` on error, and never throws:
1. Reads `state.valueOrNull`; if `null` (still loading/errored), `hasReachedMax`, or `isLoadingMore`, return `null` immediately (no-op).
2. `state = AsyncData(current.copyWith(isLoadingMore: true))`.
3. Calls `repository.getPopularMovies(page: current.page + 1)`.
4. On `Right(result)` (a `PaginatedMovies`): `state = AsyncData(current.copyWith(movies: [...current.movies, ...result.movies], page: current.page + 1, hasReachedMax: current.page + 1 >= result.totalPages, isLoadingMore: false))`; returns `null`.
5. On `Left(failure)`: `state = AsyncData(current.copyWith(isLoadingMore: false))` (existing movies untouched, loading flag cleared); returns `failure`.

**This is why next-page failures don't clobber the grid**: a page-2 failure never becomes `AsyncValue.error` — it only ever produces a returned `Failure?` that the screen inspects. `DiscoverScreen` calls `await ref.read(discoverNotifierProvider.notifier).loadNextPage()`; if the result is non-null, it shows a `ScaffoldMessenger` snackbar with the failure message. The already-loaded grid is untouched either way.

## DI bridge

`get_it` continues to own `Dio` (already registered via `RegisterModule`). Riverpod owns the feature graph on top of it:

```dart
final dioProvider = Provider<Dio>((ref) => getIt<Dio>());

final discoverRemoteDataSourceProvider = Provider<DiscoverRemoteDataSource>(
  (ref) => DiscoverRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final discoverRepositoryProvider = Provider<DiscoverRepository>(
  (ref) => DiscoverRepositoryImpl(ref.watch(discoverRemoteDataSourceProvider)),
);
```

`discoverNotifierProvider` (generated via `@riverpod` on a class) depends on `discoverRepositoryProvider`. Nothing feature-specific is registered in `get_it`/`injectable`.

## Routing

- `PlaceholderHomePage` and its route are deleted.
- `/` now renders `DiscoverScreen`.
- New route `/movie/:id` renders a minimal placeholder page (`Scaffold` + `Text('Movie $id')`) — proves navigation + path-param passing; replaced when the details feature is built.

## UI

- `GridView.builder` (2 columns), each cell is `MovieGridItem`: `CachedNetworkImage` poster (`https://image.tmdb.org/t/p/w500{posterPath}`, placeholder shimmer/spinner, error icon on failure) + title text below.
- `ScrollController` triggers `loadNextPage()` when scroll position is within 200px of `maxScrollExtent`.
- First-page `AsyncValue.loading()` → centered `CircularProgressIndicator`. First-page `AsyncValue.error()` → centered message + retry button calling `ref.invalidate(discoverNotifierProvider)`.
- Page-2+ loading → small `CircularProgressIndicator` as the last grid row (via `isLoadingMore`).
- Movies with a null `posterPath` show a placeholder poster icon instead of attempting to load an image.

## Error handling

Reuses `core/errors/failure.dart` (already defined): `Failure.network` for connection errors (`DioExceptionType.connectionError`/`connectionTimeout`), `Failure.server` for non-2xx responses (carries `statusCode`), `Failure.unexpected` for anything else (JSON decode errors, etc.).

## Testing

- `test/features/discover/data/discover_repository_impl_test.dart` — mocktail-mocked `DiscoverRemoteDataSource`; asserts success mapping and each `DioException` → `Failure` branch.
- `test/features/discover/presentation/discover_notifier_test.dart` — mocktail-mocked `DiscoverRepository`; asserts first-page load, `loadNextPage` pagination/`hasReachedMax`, and that a next-page failure doesn't clear existing movies.
- `test/features/discover/presentation/discover_screen_test.dart` — widget test with an overridden `discoverRepositoryProvider` returning a fake repository; covers loading, error+retry, and populated-grid states.

## Out of scope (explicitly deferred)

- Search, details, auth, watchlist features.
- Genre/sort filters, TV content.
- Offline caching of fetched pages (Hive is scaffolded but unused here).
- TMDB `/configuration` endpoint for dynamic image sizes (hardcoded `w500`).
