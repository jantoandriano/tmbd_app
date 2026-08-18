# Discover Feature Design

> **Revised 2026-08-18** — the original single-list `/movie/popular` grid described
> below was replaced by a sectioned layout (hero carousel + Now Playing / Coming
> Soon rails) backed by TMDB's dedicated `/movie/now_playing` and `/movie/upcoming`
> endpoints. This doc has been updated in place to reflect the current design; the
> paired plan doc (`docs/superpowers/plans/2026-08-14-discover-feature.md`) is left
> as the historical record of the original build.

**Goal:** Build the Discover feature — the app's home screen, showing movies currently in theaters and movies coming soon. First real feature built on the CineTrack scaffold; establishes the data/domain/presentation pattern later features (search, details, auth, watchlist) will follow.

**Scope:** Movies only. TMDB `/movie/now_playing` and `/movie/upcoming`, no filters/sort in this pass. Tapping a poster navigates to a placeholder `/movie/:id` route (real details screen is a separate future feature).

## Global Constraints

- All imports use `package:cinetrack/...` — relative imports fail `very_good_analysis`'s `always_use_package_imports` lint (established in the scaffold pass).
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors; `flutter analyze` must report zero issues.
- Repository methods return `Result<T>` (`typedef Result<T> = Either<Failure, T>` from `core/utils/result.dart`), never throw past the data layer.
- No new top-level dependency beyond `cached_network_image` and `google_fonts` (added across these passes) — everything else (dio, riverpod, freezed, json_serializable, get_it/injectable) is already in `pubspec.yaml` from the scaffold.
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

No usecase layer. Fetching a page each of now-playing and upcoming movies has no orchestration logic worth abstracting — the notifier calls the repository directly. Add a usecase layer later only if a second feature needs to share logic across repositories.

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
  Future<Result<PaginatedMovies>> getNowPlayingMovies({required int page});
  Future<Result<PaginatedMovies>> getUpcomingMovies({required int page});
}
```

`MovieModel` (data layer) mirrors `Movie` with `@JsonKey` mappings for TMDB's snake_case fields (`poster_path`, `vote_average`, `release_date`) and adds `Movie toEntity()`.

TMDB's `/movie/now_playing` and `/movie/upcoming` responses share the same shape (`{page, results: [...], total_pages, total_results}`) — a single top-level `MoviePageResponseModel` (freezed + json_serializable, `data/models/movie_page_response_model.dart`) decodes both: `{required int page, required List<MovieModel> results, @JsonKey(name: 'total_pages') required int totalPages}`.

```dart
// data/datasources/discover_remote_data_source.dart
abstract class DiscoverRemoteDataSource {
  /// Throws [DioException] on failure — caller (the repository) is
  /// responsible for catching and converting to [Failure].
  Future<MoviePageResponseModel> fetchNowPlayingMovies({required int page});
  Future<MoviePageResponseModel> fetchUpcomingMovies({required int page});
}
```

`DiscoverRemoteDataSourceImpl` shares one private `_fetch(path, page)` helper for both endpoints. `DiscoverRepositoryImpl.getNowPlayingMovies`/`getUpcomingMovies` share one private helper too: call the datasource, catch `DioException`, and on success map `MoviePageResponseModel` to the domain `PaginatedMovies` (each `MovieModel` via `.toEntity()`).

## Data flow

1. `DiscoverScreen` watches `discoverProvider` (an `AsyncNotifier<DiscoverState>`).
2. On first build, the notifier fetches page 1 of both feeds concurrently via `(repository.getNowPlayingMovies(page: 1), repository.getUpcomingMovies(page: 1)).wait`.
3. `DiscoverRepositoryImpl` calls the matching `DiscoverRemoteDataSource` method, which hits `GET /movie/now_playing?page=1` or `GET /movie/upcoming?page=1` and decodes the response into `List<MovieModel>` + `totalPages` via `json_serializable`.
4. On success, `MovieModel.toEntity()` maps to the domain `Movie`; repository returns `Right(PaginatedMovies(movies, page, totalPages))`.
5. On `DioException`, repository catches it and returns `Left(Failure.network(...))` or `Left(Failure.server(...))` depending on whether a response came back.
6. Notifier unwraps both `Result`s: either failure propagates as a thrown exception (`AsyncNotifier` turns it into `AsyncValue.error`, so the existing full-screen error+retry UI applies for free); both succeeding builds `DiscoverState(nowPlaying, comingSoon)`.

## State shape

```dart
@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default(<Movie>[]) List<Movie> nowPlaying,
    @Default(<Movie>[]) List<Movie> comingSoon,
  }) = _DiscoverState;
}
```

The notifier is `AsyncNotifier<DiscoverState>` (`discoverProvider`, `DiscoverNotifier`). No pagination in the UI — each rail shows a single page (20 movies) from its endpoint; there is no `loadNextPage`/infinite scroll (the horizontally-scrolling rails don't need it, and the sectioned layout replaced the original vertical infinite-scroll grid this doc originally described).

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

`discoverProvider` (generated via `@Riverpod(keepAlive: true)` on a class) depends on `discoverRepositoryProvider`. Nothing feature-specific is registered in `get_it`/`injectable`.

## Routing

- `PlaceholderHomePage` and its route are deleted.
- `/` now renders `DiscoverScreen`.
- New route `/movie/:id` renders a minimal placeholder page (`Scaffold` + `Text('Movie $id')`) — proves navigation + path-param passing; replaced when the details feature is built.
- Stub routes `/profile`, `/assistant`, `/notifications` back the app bar's avatar, Ask AI, and notifications actions (`StubPage`, `lib/core/widgets/stub_page.dart`) until those features exist.

## UI

Flat, near-mono red-on-white theme (`AppTheme`: `#f3f2f2` background, `#201e1d` text, `#ec3013` accent, Archivo font, zero border radii, 2px 40%-opacity dividers). `DiscoverScreen`'s body is a `SingleChildScrollView` `Column`, not a grid:

- **Hero carousel** (`_HeroCarousel`): `PageView` over the first 3 Now Playing movies, auto-advancing every 5s via a `PageController` + `Timer.periodic` (manual swipes update the active tick and reset the timer). 16:9 poster, "IN THEATERS" kicker, title, one-line tagline (truncated `overview` — TMDB's real `tagline` field isn't available on the list endpoints), and rectangular tick indicators matching the slide count.
- **Now Playing** / **Coming Soon** sections (`_MovieSection`): header row (title + "See all") above a horizontal `ListView` of `MovieGridItem` cards (112px wide, 2:3 poster). Now Playing cards show a rating tag; Coming Soon cards show an outlined release-date tag instead (unreleased movies have no vote average).
- First-load `AsyncValue.loading()` → centered `CircularProgressIndicator`. `AsyncValue.error()` → centered message + retry button calling `ref.invalidate(discoverProvider)`.
- Movies with a null `posterPath` show a placeholder poster icon instead of attempting to load an image.
- Bottom nav: flat 2px top divider, no elevation/pill indicator; active item accent-red, inactive gray.

## Error handling

Reuses `core/errors/failure.dart` (already defined): `Failure.network` for connection errors (`DioExceptionType.connectionError`/`connectionTimeout`), `Failure.server` for non-2xx responses (carries `statusCode`), `Failure.unexpected` for anything else (JSON decode errors, etc.).

## Testing

- `test/features/discover/data/datasources/discover_remote_data_source_test.dart` — mocktail-mocked `Dio`; asserts both `fetchNowPlayingMovies`/`fetchUpcomingMovies` decode correctly and let `DioException` propagate.
- `test/features/discover/data/repositories/discover_repository_impl_test.dart` — mocktail-mocked `DiscoverRemoteDataSource`; asserts success mapping and each `DioException` → `Failure` branch, for both repository methods.
- `test/features/discover/presentation/providers/discover_provider_test.dart` — mocktail-mocked `DiscoverRepository`; asserts both feeds load into state, and that either feed's failure surfaces as an `AsyncError`.
- `test/features/discover/presentation/screens/discover_screen_test.dart` — widget test with an overridden `discoverRepositoryProvider` returning `FakeDiscoverRepository` (separate now-playing/upcoming results); covers loading, error+retry, and populated states.

## Out of scope (explicitly deferred)

- Search, details, auth, watchlist features.
- Genre/sort filters, TV content.
- Offline caching of fetched pages (Hive is scaffolded but unused here).
- TMDB `/configuration` endpoint for dynamic image sizes (hardcoded `w500`).
