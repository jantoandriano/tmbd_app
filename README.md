# CineTrack

A Movie & TV catalog app powered by [TMDB](https://www.themoviedb.org/), built with Flutter.

## Features

- **Discover** — hero carousel (auto-playing, first 3 Now Playing movies) plus horizontally-scrolling Now Playing / Coming Soon rails, sourced from TMDB's `/movie/now_playing` and `/movie/upcoming`.
- **Movie Details** — backdrop, poster, rating/genre/runtime meta, cast strip, a watchlist toggle, a trailer button (opens YouTube externally), and an "AI Overview" panel with a Gemini-generated summary and a follow-up Q&A thread (grounded on the movie's TMDB facts, includes prior turns as context).
- Search, Watchlist, and Auth are scaffolded (`lib/features/{search,watchlist,auth}/`) but not yet implemented.

## Architecture

Each feature under `lib/features/` follows the same three-layer clean-architecture
pattern, kept intentionally small (no usecase layer — a notifier that calls a
repository directly is enough when there's no orchestration logic to share):

```
lib/features/<feature>/
  domain/
    entities/        # plain value types (freezed), no Flutter/Dio imports
    repositories/     # abstract contracts, e.g. Future<Result<T>> get...()
  data/
    models/           # freezed + json_serializable, mirrors TMDB's JSON
    datasources/      # Dio calls a single TMDB endpoint, throws DioException
    repositories/      # implements the domain contract, catches DioException,
                       # maps to Result<T> (Either<Failure, T>)
  presentation/
    providers/        # riverpod_generator: DI wiring + state
    screens/           # top-level widget for the feature
    widgets/            # supporting widgets (only split out once a widget
                        # earns its own file — see discover_screen.dart vs.
                        # details/presentation/widgets/ai_overview_panel.dart)
```

**Data flow:** screen watches a riverpod provider → provider calls a
`Repository` → `RepositoryImpl` calls a `RemoteDataSource` → `DataSource`
hits TMDB via `Dio` and decodes JSON into a `*Model` → `Model.toEntity()`
maps to the domain type → repository wraps it in `Result<T>`
(`Left(Failure)` / `Right(T)`, via `fpdart`'s `Either`) so failures never
throw past the data layer.

**State management:** `flutter_riverpod` + `riverpod_generator`. Discover
uses a `@Riverpod(keepAlive: true)` class-based `AsyncNotifier` (it's the
home screen, state should survive navigating away and back). Details uses
a plain generated family function (`movieDetailsProvider(movieId: ...)`) —
a one-shot fetch per movie id doesn't need notifier ceremony.

**Dependency injection:** `get_it` + `injectable` own two named `Dio`
singletons (registered in `core/di/register_module.dart`): the default one
configured with the TMDB `api_key` (`core/network/dio_client.dart`), and a
`@Named('gemini')` one configured with the Gemini `key` query param
(`core/network/gemini_client.dart`). Riverpod's `dioProvider` and
`geminiDioProvider` (`core/providers/`) bridge those singletons into the
riverpod provider graph; every feature's `*_di.dart` builds its
datasource/repository/service providers on top of them.

**Routing:** `go_router`, declared in `core/router/app_router.dart`.

**Theme:** `core/theme/app_theme.dart` — a flat, near-mono red-on-white
design system (`AppTheme.background/textPrimary/accent/divider`, Archivo
via `google_fonts`, zero border radii everywhere).

**Error handling:** `core/errors/failure.dart` defines a sealed `Failure`
(`network` / `server` / `cache` / `unexpected`); `core/utils/result.dart`
aliases `Either<Failure, T>` as `Result<T>`.

## Design docs

Feature specs and implementation plans live in `docs/superpowers/`:
- `specs/` — design docs (what's built and why).
- `plans/` — the task-by-task implementation plan for a spec, kept as a
  historical record of that build rather than edited after the fact.

## Getting Started

1. Get a TMDB API key: https://www.themoviedb.org/settings/api
2. Get a free Gemini API key: https://aistudio.google.com/apikey
3. Copy `env/dev.example.json` to `env/dev.json` and fill in `TMDB_API_KEY`
   and `GEMINI_API_KEY` (gitignored).
4. Run:
   ```
   flutter pub get
   flutter run --dart-define-from-file=env/dev.json
   ```
   (A VS Code launch config, "CineTrack (dev)", does this for you.)

## Testing

```
flutter test --dart-define=TMDB_API_KEY=test_key_for_ci --dart-define=GEMINI_API_KEY=test_key_for_ci
flutter analyze
```

Only `test/core/network/dio_client_test.dart` and
`test/core/network/gemini_client_test.dart` need the `--dart-define`s —
every other test overrides its repository/service provider with a fake, so
it never touches `Dio`/`EnvConfig`.

## Codegen

`freezed`, `json_serializable`, and `riverpod_generator` all run through
`build_runner`:

```
dart run build_runner build --delete-conflicting-outputs
```

Run this after adding or changing any `@freezed`, `@JsonSerializable`, or
`@riverpod`-annotated class.
