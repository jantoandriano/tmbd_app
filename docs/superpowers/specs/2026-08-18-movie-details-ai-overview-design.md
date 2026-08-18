# Movie Details + AI Overview Design

**Goal:** Replace the `/movie/:id` placeholder with a real Movie Details screen — backdrop/poster/meta, watchlist + trailer actions, cast strip, and an interactive "AI Overview" panel that answers questions about the movie (locally mocked, no real backend) instead of a plain synopsis block.

**Scope:** Read-only movie details fetched fresh from TMDB per screen open (no caching, no offline). No real AI/LLM backend, no watchlist persistence, no in-app trailer player. All three are called out below as deliberately deferred.

## Global Constraints

- All imports use `package:cinetrack/...` (established `always_use_package_imports` lint).
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors; `flutter analyze` must report zero issues.
- Repository methods return `Result<T>` (`Either<Failure, T>`), never throw past the data layer.
- New dependency: `url_launcher` (opens the trailer externally). No other new dependency — `cached_network_image`, `google_fonts`, dio, riverpod, freezed, json_serializable are already present.
- Reuses `AppTheme` tokens throughout: background/surface `#f3f2f2`, text `#201e1d`, accent `#ec3013`, accent-700 `#ae1800`, dividers `#201e1d` @ 40% opacity at 2px, radius 0 everywhere, Archivo (800 headings / 400 body).

## Architecture

```
lib/features/details/
  domain/
    entities/movie_details.dart      # MovieDetails, CastMember
    repositories/details_repository.dart
  data/
    models/movie_details_model.dart  # + GenreModel, CastMemberModel, CreditsModel, VideoModel, VideosResponseModel
    datasources/details_remote_data_source.dart
    repositories/details_repository_impl.dart
  presentation/
    providers/details_di.dart
    providers/details_provider.dart  # movieDetailsProvider(movieId) — generated family
    services/ai_overview_service.dart
    providers/ai_overview_service_provider.dart
    screens/movie_details_screen.dart  # + private widgets: _Backdrop, _PosterMetaRow,
                                        # _ActionRow, _AiOverviewPanel, _CastStrip
```

`MovieDetails` is a **separate entity from Discover's `Movie`**, not an extension of it. Discover's `Movie`/`PaginatedMovies` stay list-item-lean (used by grid cards, the hero carousel); Details needs materially more data (backdrop, runtime, genres, cast, trailer key) that Discover never uses. This matches the existing per-feature entity convention (`PaginatedMovies` already doesn't leak into other features) better than adding nullable details-only fields to a card entity.

No usecase layer, same rationale as Discover: a single "fetch full details for one movie" operation has no orchestration logic worth abstracting.

## TMDB API

`GET /movie/{id}?append_to_response=credits,videos` — one call returns the base movie fields plus:
- `genres: [{id, name}]`
- `runtime: int?` (minutes)
- `credits.cast: [{id, name, character, profile_path, order}]`
- `videos.results: [{key, site, type, official}]`

## Domain contracts

```dart
// domain/entities/movie_details.dart
@freezed
sealed class MovieDetails with _$MovieDetails {
  const factory MovieDetails({
    required int id,
    required String title,
    required String overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    required double voteAverage,
    int? runtimeMinutes,
    @Default(<String>[]) List<String> genres,
    @Default(<CastMember>[]) List<CastMember> cast,
    String? youtubeTrailerKey,
  }) = _MovieDetails;
}

@freezed
sealed class CastMember with _$CastMember {
  const factory CastMember({
    required int id,
    required String name,
    required String character,
    String? profilePath,
  }) = _CastMember;
}

// domain/repositories/details_repository.dart
abstract class DetailsRepository {
  Future<Result<MovieDetails>> getMovieDetails({required int movieId});
}
```

`MovieDetailsModel` (data layer) mirrors `MovieDetails` with `@JsonKey` mappings for TMDB's snake_case fields, plus nested `GenreModel({id, name})`, `CastMemberModel({id, name, character, @JsonKey(name: 'profile_path') profilePath})` wrapped in `CreditsModel({cast: List<CastMemberModel>})`, and `VideoModel({key, site, type, official})` wrapped in `VideosResponseModel({results: List<VideoModel>})`.

`MovieDetailsModel.toEntity()`:
- `genres` → `genres.map((g) => g.name).toList()`.
- `cast` → `credits.cast.take(10).map((c) => CastMember(id: c.id, name: c.name, character: c.character, profilePath: c.profilePath)).toList()`.
- `youtubeTrailerKey` → first `videos.results` entry where `site == 'YouTube' && type == 'Trailer'`, preferring `official == true`; `null` if none.

```dart
// data/datasources/details_remote_data_source.dart
abstract class DetailsRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MovieDetailsModel> fetchMovieDetails({required int movieId});
}
```

`DetailsRemoteDataSourceImpl.fetchMovieDetails` calls `GET /movie/{movieId}` with `queryParameters: {'append_to_response': 'credits,videos'}`. `DetailsRepositoryImpl.getMovieDetails` calls this, catches `DioException`, maps success to `MovieDetails` via `.toEntity()` — same try/catch shape as `DiscoverRepositoryImpl`.

## Data flow / state

1. `MovieDetailsScreen` reads `movieId` from the route (`int.parse(state.pathParameters['id']!)`) and watches `movieDetailsProvider(movieId)`.
2. `movieDetailsProvider` is a generated **functional** family provider (`@riverpod Future<MovieDetails> movieDetails(Ref ref, {required int movieId})`), not a full `AsyncNotifier` — there's no mutation of the fetched details, only a one-shot fetch, so a notifier class would be unused ceremony.
3. `state.when(loading: ..., error: ..., data: (details) => ...)` — same centered-spinner / message+retry pattern as `DiscoverScreen`.
4. **Watchlist toggle** and **AI Q&A turns** are both local `State` on `MovieDetailsScreen`/`_AiOverviewPanel` — plain `setState`, no provider. Per the spec: Q&A history is local to the details screen, not shared/global state, and the watchlist toggle has no persistence in this pass.

## UI

- **Header**: `AppBar` with no title, default back button (auto-supplied by `go_router` push), `bottom: PreferredSize` 2px divider — same construction as `DiscoverScreen`'s app bar, just without the title/actions.
- **Body**: `SingleChildScrollView` → `Column`:
  - `_Backdrop`: full-width 16:9 `CachedNetworkImage` of `backdropPath`, wrapped in `ColorFiltered` (grayscale matrix) — all movie imagery on this screen is grayscale, matching Discover's poster treatment.
  - `_PosterMetaRow` (16px padding, 12px gap): 92×138 grayscale poster thumbnail; title (19px Archivo 800); meta line = rating tag (`#fff2ef` bg / `#7c1405` text, star icon + `voteAverage`) + year + "·" + formatted runtime (`"2h 3m"`, blank if `runtimeMinutes` is null); genre tags (`#eae7e7` bg / `#2d2b2b` text).
  - `_ActionRow`: "Add to Watchlist" filled-accent button (plus icon) that toggles to "In Watchlist" (outlined/check) on tap, local state only; "Trailer" outlined button (play icon) — launches `youtubeTrailerKey` externally via `url_launcher` if present, else shows a "No trailer available" snackbar. Row is left-aligned, not stretched/centered.
  - 2px divider.
  - `_AiOverviewPanel` (stateful) — see below.
  - `_CastStrip`: "Cast" header (17px Archivo 800) + horizontal `ListView` of 56px circular grayscale avatar + name (11px/600) + character (10px, 55% opacity), same sizing/rail pattern as `MovieGridItem`'s horizontal lists.

### AI Overview panel

- Bounded by a 2px solid border using the `AppTheme.divider` color token — no fill, no radius, no shadow.
- Header: small sparkles icon + "AI OVERVIEW", 11px uppercase, `#ae1800`.
- The movie's `overview` rendered as the initial paragraph (13px, line-height 1.6).
- Suggested-question chips (outlined pills, accent-red border/text, radius 0): "Who directed this?", "Similar movies", "Content warnings?" — tapping one calls the same submit path as manually typing (prefill + immediate send, not just prefill-and-wait).
- Q&A thread: each submitted question is appended as a turn (question line + answer line) below the chips, in ask order; a turn shows a lightweight pending indicator until its mocked answer resolves.
- Bottom input row, separated by a 2px top divider: `TextField` (hint "Ask anything about this movie…") + circular filled accent send button (paper-plane icon). Both the button and `TextField.onSubmitted` call the same `_submit(String question)`.
- `_submit`: no-op on blank input; clears the field; appends a pending turn; calls `AiOverviewService.answer(movie: details, question: question)`; fills in the answer on completion.

### AiOverviewService (local mock)

`services/ai_overview_service.dart`, exposed via a plain `Provider` (`aiOverviewServiceProvider`) so it's swappable for a real backend later without touching the widget:

```dart
class AiOverviewService {
  Future<String> answer({required MovieDetails movie, required String question}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final q = question.toLowerCase();
    if (q.contains('direct')) {
      return "Director credits aren't in this app's data yet — check TMDB for "
          "${movie.title}'s full crew listing.";
    }
    if (q.contains('similar')) {
      final genres = movie.genres.isEmpty ? 'this genre' : movie.genres.join('/');
      return 'Movies with a similar $genres feel are a good next watch — '
          'recommendations aren\'t wired up yet, but that\'s the vibe.';
    }
    if (q.contains('warning') || q.contains('content')) {
      return 'No structured content-warning data is available for '
          '${movie.title} yet — check a parental-guide site before watching '
          'with sensitive viewers.';
    }
    return "That's outside what this mock AI Overview can answer yet — "
        'try one of the suggested questions above.';
  }
}
```

This is intentionally simple pattern-matching, not a real model — the point is the interaction shape (thread, chips, pending state), not answer quality. Swapping in a real LLM later only touches this one class.

## Error handling

Reuses `core/errors/failure.dart` — `Failure.network`/`Failure.server`/`Failure.unexpected`, identical mapping to `DiscoverRepositoryImpl`.

## Routing

- `/movie/:id` now builds `MovieDetailsScreen(movieId: int.parse(state.pathParameters['id']!))`.
- `MovieDetailsPlaceholderPage` (`lib/core/widgets/movie_details_placeholder_page.dart`) is deleted.

## Testing

- `test/features/details/data/datasources/details_remote_data_source_test.dart` — mocktail-mocked `Dio`; asserts the `append_to_response=credits,videos` query, correct decoding of nested genres/credits/videos, and `DioException` propagation.
- `test/features/details/data/repositories/details_repository_impl_test.dart` — mocktail-mocked `DetailsRemoteDataSource`; success mapping (incl. `toEntity()`'s genre/cast/trailer-key derivation) + each `DioException` → `Failure` branch.
- `test/features/details/presentation/providers/details_provider_test.dart` — mocktail-mocked `DetailsRepository`; asserts the family provider surfaces data / `AsyncError`.
- `test/features/details/presentation/services/ai_overview_service_test.dart` — pure unit tests for each canned branch (director/similar/content-warning/fallback), case-insensitive matching.
- `test/features/details/presentation/screens/movie_details_screen_test.dart` — widget test with an overridden `detailsRepositoryProvider` returning a fake repository: loading/error/loaded states; tapping a suggested chip appends a resolved turn; typing + submitting appends a turn; watchlist button toggles label/icon.
- Trailer's actual `launchUrl` call is not unit-tested (no fake platform-channel harness in this repo yet) — only the "no trailer key → snackbar" branch is covered.

## Out of scope (explicitly deferred)

- Real AI/LLM backend — `AiOverviewService` is a local mock; swapping in a real provider is a separate future pass.
- Watchlist persistence (Hive is scaffolded but unused; the toggle here is local UI state only).
- In-app trailer playback — opens YouTube externally via `url_launcher`.
- Caching/offline support for fetched details.
- Director/crew data, content-warning data, "similar movies" recommendations — the AI mock references these as future work, doesn't compute them.
