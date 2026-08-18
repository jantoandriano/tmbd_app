# Movie Details + AI Overview Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the `/movie/:id` placeholder with a real Movie Details screen — grayscale backdrop/poster, watchlist + trailer actions, cast strip, and an interactive "AI Overview" panel (locally-mocked Q&A) instead of a plain synopsis block.

**Architecture:** New `features/details/` module following the exact clean-architecture pattern already established by `features/discover/` (domain entity → data model/datasource/repository → riverpod provider → screen), with its own `MovieDetails`/`CastMember` entities kept separate from Discover's lean `Movie`. One TMDB call (`append_to_response=credits,videos`) supplies genres, runtime, cast, and trailer data together. The AI panel is backed by a local `AiOverviewService` (no network) exposed via `Provider` so it can be swapped for a real backend later without touching the widget.

**Tech Stack:** dio, flutter_riverpod + riverpod_generator, fpdart (`Either`/`Result`), freezed + json_serializable, go_router, cached_network_image, google_fonts, mocktail (tests), url_launcher (new dependency, this pass).

**Spec:** `docs/superpowers/specs/2026-08-18-movie-details-ai-overview-design.md` — read it alongside this plan; it has the full rationale (why a separate entity from `Movie`, why the AI service is a local mock, why watchlist has no persistence).

## Global Constraints

- All imports use `package:cinetrack/...` — relative imports fail `very_good_analysis`'s `always_use_package_imports` lint.
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors after every task that adds `@freezed`/`@JsonSerializable`/`@riverpod` code.
- `flutter analyze` must report zero issues after every task.
- Repository methods return `Result<T>` (`Either<Failure, T>`) — never throw past the data layer boundary (the datasource may throw `DioException`; the repository catches it).
- Reuses `AppTheme` tokens throughout: `AppTheme.background`/`surface` `#f3f2f2`, `AppTheme.textPrimary` `#201e1d`, `AppTheme.accent` `#ec3013`, `#ae1800` accent-700, `AppTheme.divider` (`#201e1d` @ 40%, 2px), radius 0 everywhere, `GoogleFonts.archivo` (800 headings / 400 body).
- No new dependency beyond `url_launcher`.
- Tests that exercise `DioClient.create()` directly need `--dart-define=TMDB_API_KEY=test_key_for_ci`; tests that override `detailsRepositoryProvider`/`discoverRepositoryProvider` do not.

---

## Task 1: `url_launcher` dependency, shared `dioProvider`, remove details placeholders

**Files:**
- Modify: `pubspec.yaml` (add `url_launcher`)
- Create: `lib/core/providers/dio_provider.dart`
- Modify: `lib/features/discover/presentation/providers/discover_di.dart`
- Delete: `lib/features/details/domain/placeholder.dart`, `lib/features/details/data/placeholder.dart`, `lib/features/details/presentation/placeholder.dart`

**Interfaces:**
- Produces: `dioProvider` (`Provider<Dio>`, moved to core so both `discover_di.dart` and the new `details_di.dart` in Task 6 share one definition instead of declaring it twice).

This is a pure refactor (no behavior change) plus scaffold cleanup — no new test, just verify the existing suite stays green.

- [ ] **Step 1: Add the `url_launcher` dependency**

Run: `flutter pub add url_launcher`

- [ ] **Step 2: Extract the shared `dioProvider`**

Create `lib/core/providers/dio_provider.dart`:
```dart
import 'package:cinetrack/core/di/injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => getIt<Dio>());
```

- [ ] **Step 3: Point `discover_di.dart` at the shared provider**

In `lib/features/discover/presentation/providers/discover_di.dart`, replace:
```dart
import 'package:cinetrack/core/di/injection.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => getIt<Dio>());

final discoverRemoteDataSourceProvider = Provider<DiscoverRemoteDataSource>(
  (ref) => DiscoverRemoteDataSourceImpl(ref.watch(dioProvider)),
);
```
with:
```dart
import 'package:cinetrack/core/providers/dio_provider.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverRemoteDataSourceProvider = Provider<DiscoverRemoteDataSource>(
  (ref) => DiscoverRemoteDataSourceImpl(ref.watch(dioProvider)),
);
```
(the rest of the file — `discoverRepositoryProvider` — is unchanged).

- [ ] **Step 4: Remove the details feature placeholders**

```bash
rm lib/features/details/domain/placeholder.dart lib/features/details/data/placeholder.dart lib/features/details/presentation/placeholder.dart
```

- [ ] **Step 5: Verify nothing broke**

Run: `flutter analyze`
Expected: No issues.

Run: `flutter test test/features/discover/`
Expected: All pass (the `dioProvider` refactor must not change Discover's behavior).

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/providers/dio_provider.dart lib/features/discover/presentation/providers/discover_di.dart
git rm lib/features/details/domain/placeholder.dart lib/features/details/data/placeholder.dart lib/features/details/presentation/placeholder.dart
git commit -m "chore(details): add url_launcher, share dioProvider, drop details placeholders"
```

---

## Task 2: `MovieDetails`/`CastMember` domain entities

**Files:**
- Create: `lib/features/details/domain/entities/movie_details.dart`

**Interfaces:**
- Produces: `MovieDetails` (`id, title, overview, posterPath, backdropPath, releaseDate, voteAverage, runtimeMinutes, genres: List<String>, cast: List<CastMember>, youtubeTrailerKey`), `CastMember` (`id, name, character, profilePath`). Consumed by Task 3 (model's `toEntity()`), Task 5 (repository), Task 6 (provider), Task 8/9 (screen).

No test — these are plain freezed value holders with no logic, same as Discover's `Movie`/`PaginatedMovies` (exercised indirectly by later tasks' tests).

- [ ] **Step 1: Write the entities**

Create `lib/features/details/domain/entities/movie_details.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details.freezed.dart';

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
```

- [ ] **Step 2: Generate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Succeeds, no errors.

- [ ] **Step 3: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 4: Commit**

```bash
git add lib/features/details/domain/entities
git commit -m "feat(details): add MovieDetails and CastMember entities"
```

---

## Task 3: `MovieDetailsModel` + nested TMDB response models

**Files:**
- Create: `lib/features/details/data/models/movie_details_model.dart`
- Test: `test/features/details/data/models/movie_details_model_test.dart`

**Interfaces:**
- Consumes: `MovieDetails`/`CastMember` (Task 2).
- Produces: `MovieDetailsModel` (+ `GenreModel`, `CastMemberModel`, `CreditsModel`, `VideoModel`, `VideosResponseModel`), `MovieDetailsModel.fromJson(Map<String, dynamic>)`, `MovieDetailsModel.toEntity() -> MovieDetails`. Consumed by Task 4 (datasource), Task 5 (repository).

- [ ] **Step 1: Write the failing tests**

Create `test/features/details/data/models/movie_details_model_test.dart`:
```dart
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _json({
  List<Map<String, dynamic>> genres = const [],
  List<Map<String, dynamic>> cast = const [],
  List<Map<String, dynamic>> videos = const [],
  bool includeCredits = true,
  bool includeVideos = true,
}) => <String, dynamic>{
  'id': 550,
  'title': 'Fight Club',
  'overview': 'An insomniac office worker...',
  'poster_path': '/poster.jpg',
  'backdrop_path': '/backdrop.jpg',
  'release_date': '1999-10-15',
  'vote_average': 8.4,
  'runtime': 139,
  'genres': genres,
  if (includeCredits) 'credits': <String, dynamic>{'cast': cast},
  if (includeVideos) 'videos': <String, dynamic>{'results': videos},
};

void main() {
  test('fromJson maps base TMDB fields', () {
    final model = MovieDetailsModel.fromJson(_json());

    expect(model.id, 550);
    expect(model.title, 'Fight Club');
    expect(model.posterPath, '/poster.jpg');
    expect(model.backdropPath, '/backdrop.jpg');
    expect(model.releaseDate, '1999-10-15');
    expect(model.voteAverage, 8.4);
    expect(model.runtime, 139);
  });

  test('toEntity maps genre names', () {
    final model = MovieDetailsModel.fromJson(
      _json(genres: [
        {'id': 18, 'name': 'Drama'},
        {'id': 53, 'name': 'Thriller'},
      ]),
    );

    expect(model.toEntity().genres, ['Drama', 'Thriller']);
  });

  test('toEntity sorts cast by order and caps at 10', () {
    final cast = List.generate(
      12,
      (i) => {
        'id': i,
        'name': 'Actor $i',
        'character': 'Role $i',
        'order': 11 - i,
        'profile_path': null,
      },
    );
    final model = MovieDetailsModel.fromJson(_json(cast: cast));

    final entityCast = model.toEntity().cast;

    expect(entityCast, hasLength(10));
    expect(entityCast.first.name, 'Actor 11');
    expect(entityCast.last.name, 'Actor 2');
  });

  test('toEntity prefers the official YouTube trailer', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'unofficial',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': false,
          },
          {
            'key': 'official',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': true,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, 'official');
  });

  test('toEntity falls back to the first trailer when none are official', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'first',
            'site': 'YouTube',
            'type': 'Trailer',
            'official': false,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, 'first');
  });

  test('toEntity returns a null trailer key when none match', () {
    final model = MovieDetailsModel.fromJson(
      _json(
        videos: [
          {
            'key': 'teaser',
            'site': 'YouTube',
            'type': 'Teaser',
            'official': true,
          },
        ],
      ),
    );

    expect(model.toEntity().youtubeTrailerKey, isNull);
  });

  test('toEntity handles a response with no credits/videos keys', () {
    final model = MovieDetailsModel.fromJson(
      _json(includeCredits: false, includeVideos: false),
    );

    final entity = model.toEntity();

    expect(entity.cast, isEmpty);
    expect(entity.youtubeTrailerKey, isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/data/models/`
Expected: FAIL to compile — `MovieDetailsModel` doesn't exist yet.

- [ ] **Step 3: Write the models**

Create `lib/features/details/data/models/movie_details_model.dart`:
```dart
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details_model.freezed.dart';
part 'movie_details_model.g.dart';

@freezed
sealed class GenreModel with _$GenreModel {
  const factory GenreModel({required int id, required String name}) =
      _GenreModel;

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
}

@freezed
sealed class CastMemberModel with _$CastMemberModel {
  const factory CastMemberModel({
    required int id,
    required String name,
    required String character,
    required int order,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CastMemberModel;

  factory CastMemberModel.fromJson(Map<String, dynamic> json) =>
      _$CastMemberModelFromJson(json);
}

@freezed
sealed class CreditsModel with _$CreditsModel {
  const factory CreditsModel({
    @Default(<CastMemberModel>[]) List<CastMemberModel> cast,
  }) = _CreditsModel;

  factory CreditsModel.fromJson(Map<String, dynamic> json) =>
      _$CreditsModelFromJson(json);
}

@freezed
sealed class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String key,
    required String site,
    required String type,
    @Default(false) bool official,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
}

@freezed
sealed class VideosResponseModel with _$VideosResponseModel {
  const factory VideosResponseModel({
    @Default(<VideoModel>[]) List<VideoModel> results,
  }) = _VideosResponseModel;

  factory VideosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseModelFromJson(json);
}

@freezed
sealed class MovieDetailsModel with _$MovieDetailsModel {
  const MovieDetailsModel._();

  const factory MovieDetailsModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'vote_average') required double voteAverage,
    int? runtime,
    @Default(<GenreModel>[]) List<GenreModel> genres,
    CreditsModel? credits,
    VideosResponseModel? videos,
  }) = _MovieDetailsModel;

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsModelFromJson(json);

  MovieDetails toEntity() {
    final sortedCast = [...?credits?.cast]
      ..sort((a, b) => a.order.compareTo(b.order));

    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      runtimeMinutes: runtime,
      genres: genres.map((g) => g.name).toList(),
      cast: sortedCast
          .take(10)
          .map(
            (c) => CastMember(
              id: c.id,
              name: c.name,
              character: c.character,
              profilePath: c.profilePath,
            ),
          )
          .toList(),
      youtubeTrailerKey: _selectTrailerKey(videos?.results ?? const []),
    );
  }
}

String? _selectTrailerKey(List<VideoModel> videos) {
  final trailers = videos
      .where((v) => v.site == 'YouTube' && v.type == 'Trailer')
      .toList();
  if (trailers.isEmpty) return null;

  final official = trailers.where((v) => v.official).toList();
  return (official.isNotEmpty ? official.first : trailers.first).key;
}
```

- [ ] **Step 4: Generate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Succeeds, no errors.

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/details/data/models/`
Expected: PASS

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add lib/features/details/data/models test/features/details/data/models
git commit -m "feat(details): add MovieDetailsModel with genres/cast/trailer mapping"
```

---

## Task 4: `DetailsRemoteDataSource`

**Files:**
- Create: `lib/features/details/data/datasources/details_remote_data_source.dart`
- Test: `test/features/details/data/datasources/details_remote_data_source_test.dart`

**Interfaces:**
- Consumes: `Dio` (constructor param), `MovieDetailsModel.fromJson` (Task 3).
- Produces: `abstract class DetailsRemoteDataSource { Future<MovieDetailsModel> fetchMovieDetails({required int movieId}); }`, `DetailsRemoteDataSourceImpl(Dio dio)`. Consumed by Task 5 (repository).

- [ ] **Step 1: Write the failing tests**

Create `test/features/details/data/datasources/details_remote_data_source_test.dart`:
```dart
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DetailsRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = DetailsRemoteDataSourceImpl(dio);
  });

  test(
    'fetchMovieDetails requests append_to_response=credits,videos and decodes the response',
    () async {
      final json = <String, dynamic>{
        'id': 550,
        'title': 'Fight Club',
        'overview': 'overview',
        'vote_average': 8.4,
        'genres': <Map<String, dynamic>>[],
      };

      when(
        () => dio.get<Map<String, dynamic>>(
          '/movie/550',
          queryParameters: {'append_to_response': 'credits,videos'},
        ),
      ).thenAnswer(
        (_) async =>
            Response(data: json, requestOptions: RequestOptions(path: '/movie/550')),
      );

      final result = await dataSource.fetchMovieDetails(movieId: 550);

      expect(result, isA<MovieDetailsModel>());
      expect(result.id, 550);
      expect(result.title, 'Fight Club');
    },
  );

  test('fetchMovieDetails lets DioException propagate', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        '/movie/550',
        queryParameters: {'append_to_response': 'credits,videos'},
      ),
    ).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/movie/550')),
    );

    expect(
      () => dataSource.fetchMovieDetails(movieId: 550),
      throwsA(isA<DioException>()),
    );
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/data/datasources/`
Expected: FAIL to compile — `DetailsRemoteDataSource`/`DetailsRemoteDataSourceImpl` don't exist yet.

- [ ] **Step 3: Write the datasource**

Create `lib/features/details/data/datasources/details_remote_data_source.dart`:
```dart
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:dio/dio.dart';

abstract class DetailsRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MovieDetailsModel> fetchMovieDetails({required int movieId});
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  DetailsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MovieDetailsModel> fetchMovieDetails({required int movieId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/$movieId',
      queryParameters: {'append_to_response': 'credits,videos'},
    );
    return MovieDetailsModel.fromJson(response.data!);
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/details/data/datasources/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/details/data/datasources test/features/details/data/datasources
git commit -m "feat(details): add DetailsRemoteDataSource"
```

---

## Task 5: `DetailsRepository`

**Files:**
- Create: `lib/features/details/domain/repositories/details_repository.dart`
- Create: `lib/features/details/data/repositories/details_repository_impl.dart`
- Test: `test/features/details/data/repositories/details_repository_impl_test.dart`

**Interfaces:**
- Consumes: `DetailsRemoteDataSource` (Task 4), `Result<T>`/`Failure` (`lib/core/utils/result.dart`, `lib/core/errors/failure.dart`), `MovieDetails` (Task 2).
- Produces: `abstract class DetailsRepository { Future<Result<MovieDetails>> getMovieDetails({required int movieId}); }`, `DetailsRepositoryImpl(DetailsRemoteDataSource)`. Consumed by Task 6 (provider), Task 8/9 (test overrides).

- [ ] **Step 1: Write the failing tests**

Create `test/features/details/data/repositories/details_repository_impl_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/models/movie_details_model.dart';
import 'package:cinetrack/features/details/data/repositories/details_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDetailsRemoteDataSource extends Mock
    implements DetailsRemoteDataSource {}

void main() {
  late MockDetailsRemoteDataSource dataSource;
  late DetailsRepositoryImpl repository;

  setUp(() {
    dataSource = MockDetailsRemoteDataSource();
    repository = DetailsRepositoryImpl(dataSource);
  });

  test('returns Right(MovieDetails) on success', () async {
    when(() => dataSource.fetchMovieDetails(movieId: 550)).thenAnswer(
      (_) async => const MovieDetailsModel(
        id: 550,
        title: 'Fight Club',
        overview: 'overview',
        voteAverage: 8.4,
      ),
    );

    final result = await repository.getMovieDetails(movieId: 550);

    expect(result.isRight(), isTrue);
    result.match(
      (l) => fail('expected Right, got Left($l)'),
      (r) => expect(r.title, 'Fight Club'),
    );
  });

  test(
    'returns Left(ServerFailure) when DioException carries a response',
    () async {
      when(() => dataSource.fetchMovieDetails(movieId: 550)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/movie/550'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/movie/550'),
          ),
        ),
      );

      final result = await repository.getMovieDetails(movieId: 550);

      expect(result.isLeft(), isTrue);
      result.match(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    },
  );

  test(
    'returns Left(NetworkFailure) when DioException has no response',
    () async {
      when(() => dataSource.fetchMovieDetails(movieId: 550)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/movie/550')),
      );

      final result = await repository.getMovieDetails(movieId: 550);

      result.match(
        (l) => expect(l, isA<NetworkFailure>()),
        (r) => fail('expected Left, got Right($r)'),
      );
    },
  );

  test('returns Left(UnexpectedFailure) on a non-Dio exception', () async {
    when(
      () => dataSource.fetchMovieDetails(movieId: 550),
    ).thenThrow(Exception('boom'));

    final result = await repository.getMovieDetails(movieId: 550);

    result.match(
      (l) => expect(l, isA<UnexpectedFailure>()),
      (r) => fail('expected Left, got Right($r)'),
    );
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/data/repositories/`
Expected: FAIL to compile — `DetailsRepository`/`DetailsRepositoryImpl` don't exist yet.

- [ ] **Step 3: Write the repository interface and implementation**

Create `lib/features/details/domain/repositories/details_repository.dart`:
```dart
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';

abstract class DetailsRepository {
  Future<Result<MovieDetails>> getMovieDetails({required int movieId});
}
```

Create `lib/features/details/data/repositories/details_repository_impl.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  DetailsRepositoryImpl(this._remoteDataSource);

  final DetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<MovieDetails>> getMovieDetails({
    required int movieId,
  }) async {
    try {
      final response = await _remoteDataSource.fetchMovieDetails(
        movieId: movieId,
      );
      return Right(response.toEntity());
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        return Left(
          Failure.server(
            e.message ?? 'Server error',
            statusCode: response.statusCode,
          ),
        );
      }
      return Left(Failure.network(e.message ?? 'Network error'));
      // Deliberate catch-all: anything not a DioException (JSON decode
      // errors, etc.) still needs to become a Failure, not propagate.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/details/data/repositories/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/details/domain/repositories lib/features/details/data/repositories test/features/details/data/repositories
git commit -m "feat(details): add DetailsRepository"
```

---

## Task 6: DI wiring, `movieDetailsProvider`, and the shared test fake

**Files:**
- Create: `lib/features/details/presentation/providers/details_di.dart`
- Create: `lib/features/details/presentation/providers/details_provider.dart`
- Create: `test/helpers/fake_details_repository.dart`
- Test: `test/features/details/presentation/providers/details_provider_test.dart`

**Interfaces:**
- Consumes: `DetailsRepository` (Task 5), `dioProvider` (Task 1).
- Produces: `detailsRepositoryProvider` (`Provider<DetailsRepository>`), `movieDetailsProvider` (generated family, `movieDetailsProvider(movieId: int)` → `AsyncValue<MovieDetails>`). Consumed by Task 8/9 (screen).
- `test/helpers/fake_details_repository.dart` produces `FakeDetailsRepository(Result<MovieDetails> result)` implementing `DetailsRepository`, reused by Task 8/9's screen test and Task 10's router test.

- [ ] **Step 1: Write the DI wiring (no test — trivial composition, exercised by the provider test below)**

Create `lib/features/details/presentation/providers/details_di.dart`:
```dart
import 'package:cinetrack/core/providers/dio_provider.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/repositories/details_repository_impl.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailsRemoteDataSourceProvider = Provider<DetailsRemoteDataSource>(
  (ref) => DetailsRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final detailsRepositoryProvider = Provider<DetailsRepository>(
  (ref) => DetailsRepositoryImpl(ref.watch(detailsRemoteDataSourceProvider)),
);
```

- [ ] **Step 2: Write the shared test fake**

Create `test/helpers/fake_details_repository.dart`:
```dart
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';

class FakeDetailsRepository implements DetailsRepository {
  FakeDetailsRepository(this.result);

  final Result<MovieDetails> result;

  @override
  Future<Result<MovieDetails>> getMovieDetails({
    required int movieId,
  }) async => result;
}
```

- [ ] **Step 3: Write the failing provider test**

Create `test/features/details/presentation/providers/details_provider_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/details/presentation/providers/details_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  late MockDetailsRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockDetailsRepository();
    container = ProviderContainer(
      overrides: [detailsRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('surfaces the repository result as data', () async {
    when(() => repository.getMovieDetails(movieId: 550)).thenAnswer(
      (_) async => const Right(
        MovieDetails(
          id: 550,
          title: 'Fight Club',
          overview: 'overview',
          voteAverage: 8.4,
        ),
      ),
    );

    final details = await container.read(
      movieDetailsProvider(movieId: 550).future,
    );

    expect(details.title, 'Fight Club');
  });

  test('surfaces a repository failure as an AsyncError', () async {
    when(
      () => repository.getMovieDetails(movieId: 550),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    container.listen(movieDetailsProvider(movieId: 550), (_, _) {});
    await container.pump();

    final state = container.read(movieDetailsProvider(movieId: 550));
    expect(state.hasError, isTrue);
    expect(state.error, isA<Failure>());
  });
}
```

- [ ] **Step 4: Run tests to verify they fail**

Run: `flutter test test/features/details/presentation/providers/`
Expected: FAIL to compile — `movieDetailsProvider` doesn't exist yet.

- [ ] **Step 5: Write the provider**

Create `lib/features/details/presentation/providers/details_provider.dart`:
```dart
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_provider.g.dart';

@riverpod
Future<MovieDetails> movieDetails(Ref ref, {required int movieId}) async {
  final repository = ref.watch(detailsRepositoryProvider);
  final result = await repository.getMovieDetails(movieId: movieId);

  return result.match((failure) => throw failure, (details) => details);
}
```

- [ ] **Step 6: Generate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Succeeds, no errors.

- [ ] **Step 7: Run tests to verify they pass**

Run: `flutter test test/features/details/presentation/providers/`
Expected: PASS

- [ ] **Step 8: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 9: Commit**

```bash
git add lib/features/details/presentation/providers test/helpers/fake_details_repository.dart test/features/details/presentation/providers
git commit -m "feat(details): add DI wiring and movieDetailsProvider"
```

---

## Task 7: `AiOverviewService`

**Files:**
- Create: `lib/features/details/presentation/services/ai_overview_service.dart`
- Create: `lib/features/details/presentation/providers/ai_overview_service_provider.dart`
- Test: `test/features/details/presentation/services/ai_overview_service_test.dart`

**Interfaces:**
- Consumes: `MovieDetails` (Task 2).
- Produces: `AiOverviewService.answer({required MovieDetails movie, required String question}) -> Future<String>`, `aiOverviewServiceProvider` (`Provider<AiOverviewService>`). Consumed by Task 9 (AI panel).

- [ ] **Step 1: Write the failing tests**

Create `test/features/details/presentation/services/ai_overview_service_test.dart`:
```dart
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const movie = MovieDetails(
    id: 550,
    title: 'Fight Club',
    overview: 'overview',
    voteAverage: 8.4,
    genres: ['Drama', 'Thriller'],
  );

  late AiOverviewService service;

  setUp(() => service = AiOverviewService());

  test('answers a director question', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'Who directed this?',
    );

    expect(answer, contains('Fight Club'));
  });

  test('answers a similar-movies question using the genres', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'Similar movies',
    );

    expect(answer, contains('Drama/Thriller'));
  });

  test('answers a content-warnings question case-insensitively', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'CONTENT WARNINGS?',
    );

    expect(answer, contains('Fight Club'));
  });

  test('falls back to a generic answer for anything else', () async {
    final answer = await service.answer(
      movie: movie,
      question: 'What is the meaning of life?',
    );

    expect(answer, contains('suggested questions'));
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/presentation/services/`
Expected: FAIL to compile — `AiOverviewService` doesn't exist yet.

- [ ] **Step 3: Write the service**

Create `lib/features/details/presentation/services/ai_overview_service.dart`:
```dart
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';

/// Local, network-free mock for the AI Overview panel's Q&A. Deliberately
/// simple keyword matching — the point is the interaction shape (a growing
/// thread with a pending state), not answer quality. Swapping in a real
/// backend later only touches this class.
class AiOverviewService {
  Future<String> answer({
    required MovieDetails movie,
    required String question,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final q = question.toLowerCase();

    if (q.contains('direct')) {
      return "Director credits aren't in this app's data yet — check TMDB "
          "for ${movie.title}'s full crew listing.";
    }
    if (q.contains('similar')) {
      final genres = movie.genres.isEmpty
          ? 'this genre'
          : movie.genres.join('/');
      return 'Movies with a similar $genres feel are a good next watch — '
          "recommendations aren't wired up yet, but that's the vibe.";
    }
    if (q.contains('warning') || q.contains('content')) {
      return 'No structured content-warning data is available for '
          '${movie.title} yet — check a parental-guide site before '
          'watching with sensitive viewers.';
    }
    return "That's outside what this mock AI Overview can answer yet — "
        'try one of the suggested questions above.';
  }
}
```

- [ ] **Step 4: Write the provider**

Create `lib/features/details/presentation/providers/ai_overview_service_provider.dart`:
```dart
import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiOverviewServiceProvider = Provider<AiOverviewService>(
  (ref) => AiOverviewService(),
);
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/details/presentation/services/`
Expected: PASS

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add lib/features/details/presentation/services lib/features/details/presentation/providers/ai_overview_service_provider.dart test/features/details/presentation/services
git commit -m "feat(details): add local AiOverviewService mock"
```

---

## Task 8: `MovieDetailsScreen` — layout, backdrop/poster/meta, cast strip

**Files:**
- Create: `lib/features/details/presentation/screens/movie_details_screen.dart`
- Test: `test/features/details/presentation/screens/movie_details_screen_test.dart`

**Interfaces:**
- Consumes: `movieDetailsProvider` (Task 6), `MovieDetails`/`CastMember` (Task 2), `detailsRepositoryProvider` (Task 6, for test overrides), `FakeDetailsRepository` (Task 6).
- Produces: `MovieDetailsScreen({required int movieId})`. Consumed by Task 9 (adds the action row + AI panel to this same file), Task 10 (router).

This task builds the screen's static/display parts (header, backdrop, poster+meta, cast strip) and loading/error states. Task 9 adds the interactive action row and AI Overview panel on top.

- [ ] **Step 1: Write the failing tests**

Create `test/features/details/presentation/screens/movie_details_screen_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/details/presentation/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_details_repository.dart';

const _movie = MovieDetails(
  id: 550,
  title: 'Fight Club',
  overview:
      'An insomniac office worker and a soap salesman build a global organization.',
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
  runtimeMinutes: 139,
  genres: ['Drama', 'Thriller'],
  cast: [
    CastMember(id: 1, name: 'Edward Norton', character: 'The Narrator'),
  ],
);

Widget _wrap(Widget child, {required Result<MovieDetails> result}) =>
    ProviderScope(
      overrides: [
        detailsRepositoryProvider.overrideWithValue(
          FakeDetailsRepository(result),
        ),
      ],
      child: MaterialApp(home: child),
    );

void main() {
  testWidgets('shows a loading indicator while fetching', (tester) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an error state with a retry button on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const MovieDetailsScreen(movieId: 550),
        result: const Left(Failure.network('offline')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });

  testWidgets('shows title, meta, genres, and cast when loaded', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fight Club'), findsOneWidget);
    expect(find.textContaining('8.4'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('Thriller'), findsOneWidget);
    expect(find.text('Edward Norton'), findsOneWidget);
    expect(find.text('The Narrator'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/presentation/screens/`
Expected: FAIL to compile — `MovieDetailsScreen` doesn't exist yet.

- [ ] **Step 3: Write the screen**

Create `lib/features/details/presentation/screens/movie_details_screen.dart`:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const _grayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieDetailsProvider(movieId: movieId));

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(movieDetailsProvider(movieId: movieId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (details) => _DetailsBody(details: details),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Backdrop(path: details.backdropPath),
          _PosterMetaRow(details: details),
          if (details.cast.isNotEmpty) _CastStrip(cast: details.cast),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColorFiltered(
        colorFilter: _grayscale,
        child: path == null
            ? const ColoredBox(color: Colors.black12)
            : CachedNetworkImage(
                imageUrl: '${ApiConstants.tmdbImageBaseUrl}$path',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _PosterMetaRow extends StatelessWidget {
  const _PosterMetaRow({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    final posterPath = details.posterPath;
    final metaParts = [
      _year(details.releaseDate),
      _formatRuntime(details.runtimeMinutes),
    ].where((part) => part.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            height: 138,
            child: ColorFiltered(
              colorFilter: _grayscale,
              child: posterPath == null
                  ? const ColoredBox(color: Colors.black12)
                  : CachedNetworkImage(
                      imageUrl:
                          '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.title,
                  style: GoogleFonts.archivo(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: const Color(0xfffff2ef),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Color(0xff7c1405),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            details.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.archivo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff7c1405),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        metaParts,
                        style: GoogleFonts.archivo(
                          fontSize: 12,
                          color: AppTheme.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
                if (details.genres.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: details.genres
                        .map(
                          (genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            color: const Color(0xffeae7e7),
                            child: Text(
                              genre,
                              style: GoogleFonts.archivo(
                                fontSize: 11,
                                color: const Color(0xff2d2b2b),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CastStrip extends StatelessWidget {
  const _CastStrip({required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Cast',
            style: GoogleFonts.archivo(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 56 + 8 + 14 + 2 + 12,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = cast[index];
              return SizedBox(
                width: 72,
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: ColorFiltered(
                          colorFilter: _grayscale,
                          child: member.profilePath == null
                              ? const ColoredBox(
                                  color: Colors.black12,
                                  child: Icon(Icons.person),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${ApiConstants.tmdbImageBaseUrl}${member.profilePath}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      member.character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 10,
                        color: AppTheme.textPrimary.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String _year(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? '' : date.year.toString();
}

String _formatRuntime(int? minutes) {
  if (minutes == null || minutes <= 0) return '';
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (hours == 0) return '${remainder}m';
  return '${hours}h ${remainder}m';
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/details/presentation/screens/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/details/presentation/screens test/features/details/presentation/screens
git commit -m "feat(details): add MovieDetailsScreen layout with backdrop/poster/meta/cast"
```

---

## Task 9: Action row (watchlist + trailer) and AI Overview panel

**Files:**
- Modify: `lib/features/details/presentation/screens/movie_details_screen.dart`
- Modify: `test/features/details/presentation/screens/movie_details_screen_test.dart`

**Interfaces:**
- Consumes: `aiOverviewServiceProvider`/`AiOverviewService` (Task 7), `url_launcher`'s `launchUrl`/`canLaunchUrl`.
- Produces: nothing new consumed by later tasks — this completes the screen's interactive surface.

- [ ] **Step 1: Add the failing interaction tests**

Append to `test/features/details/presentation/screens/movie_details_screen_test.dart` (inside `main()`, after the existing tests — add the import for `MovieDetails`'s `youtubeTrailerKey` field is already covered by the existing `_movie` constant; add a second fixture with a trailer key):

```dart
  testWidgets('toggles the watchlist button label on tap', (tester) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to Watchlist'), findsOneWidget);

    await tester.tap(find.text('Add to Watchlist'));
    await tester.pump();

    expect(find.text('In Watchlist'), findsOneWidget);
  });

  testWidgets('shows a snackbar when there is no trailer', (tester) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trailer'));
    await tester.pump();

    expect(find.text('No trailer available'), findsOneWidget);
  });

  testWidgets('tapping a suggested chip appends a Q&A turn', (tester) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Who directed this?'), findsWidgets);

    await tester.tap(find.text('Who directed this?').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Fight Club'), findsWidgets);
  });

  testWidgets('submitting a typed question appends a Q&A turn', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const MovieDetailsScreen(movieId: 550), result: const Right(_movie)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'What is the meaning of life?',
    );
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('What is the meaning of life?'), findsOneWidget);
    expect(find.textContaining('suggested questions'), findsOneWidget);
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/details/presentation/screens/`
Expected: FAIL — no "Add to Watchlist"/"Trailer" buttons, no AI panel, no `TextField` yet.

- [ ] **Step 3: Add `url_launcher` import and the action row + AI panel widgets**

In `lib/features/details/presentation/screens/movie_details_screen.dart`, add imports at the top:
```dart
import 'package:cinetrack/features/details/presentation/providers/ai_overview_service_provider.dart';
import 'package:url_launcher/url_launcher.dart';
```
(alongside the existing imports — keep them alphabetically ordered with the rest).

Update `_DetailsBody` to include the action row, a divider, and the AI panel:
```dart
class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Backdrop(path: details.backdropPath),
          _PosterMetaRow(details: details),
          _ActionRow(details: details),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _AiOverviewPanel(movie: details),
          ),
          if (details.cast.isNotEmpty) _CastStrip(cast: details.cast),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
```

Add the action row widget:
```dart
class _ActionRow extends StatefulWidget {
  const _ActionRow({required this.details});

  final MovieDetails details;

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  bool _inWatchlist = false;

  Future<void> _openTrailer() async {
    final key = widget.details.youtubeTrailerKey;
    if (key == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trailer available')),
      );
      return;
    }
    await launchUrl(
      Uri.parse('https://www.youtube.com/watch?v=$key'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () => setState(() => _inWatchlist = !_inWatchlist),
            style: ElevatedButton.styleFrom(
              backgroundColor: _inWatchlist
                  ? const Color(0xffeae7e7)
                  : AppTheme.accent,
              foregroundColor: _inWatchlist
                  ? AppTheme.textPrimary
                  : Colors.white,
            ),
            icon: Icon(_inWatchlist ? Icons.check : Icons.add),
            label: Text(_inWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _openTrailer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Trailer'),
          ),
        ],
      ),
    );
  }
}
```

Add the AI Overview panel:
```dart
class _QaTurn {
  _QaTurn(this.question, {this.answer});

  final String question;
  String? answer;
}

const _suggestedQuestions = [
  'Who directed this?',
  'Similar movies',
  'Content warnings?',
];

class _AiOverviewPanel extends ConsumerStatefulWidget {
  const _AiOverviewPanel({required this.movie});

  final MovieDetails movie;

  @override
  ConsumerState<_AiOverviewPanel> createState() => _AiOverviewPanelState();
}

class _AiOverviewPanelState extends ConsumerState<_AiOverviewPanel> {
  final _controller = TextEditingController();
  final _turns = <_QaTurn>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();
    final turn = _QaTurn(trimmed);
    setState(() => _turns.add(turn));

    final answer = await ref
        .read(aiOverviewServiceProvider)
        .answer(movie: widget.movie, question: trimmed);

    if (!mounted) return;
    setState(() => turn.answer = answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.divider, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: Color(0xffae1800),
              ),
              const SizedBox(width: 6),
              Text(
                'AI OVERVIEW',
                style: GoogleFonts.archivo(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.12 * 11,
                  color: const Color(0xffae1800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.movie.overview,
            style: GoogleFonts.archivo(
              fontSize: 13,
              height: 1.6,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedQuestions
                .map(
                  (question) => OutlinedButton(
                    onPressed: () => _submit(question),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.accent),
                      foregroundColor: AppTheme.accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      question,
                      style: GoogleFonts.archivo(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
          for (final turn in _turns) ...[
            const SizedBox(height: 12),
            Text(
              turn.question,
              style: GoogleFonts.archivo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              turn.answer ?? '…',
              style: GoogleFonts.archivo(
                fontSize: 13,
                height: 1.6,
                color: AppTheme.textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything about this movie…',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _submit,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _submit(_controller.text),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.send, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/details/presentation/screens/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/details/presentation/screens test/features/details/presentation/screens
git commit -m "feat(details): add watchlist/trailer actions and AI Overview Q&A panel"
```

---

## Task 10: Routing and final verification

**Files:**
- Modify: `lib/core/router/app_router.dart`
- Delete: `lib/core/widgets/movie_details_placeholder_page.dart`
- Modify: `test/core/router/app_router_test.dart`

**Interfaces:**
- Consumes: `MovieDetailsScreen` (Task 8/9), `detailsRepositoryProvider` (Task 6), `FakeDetailsRepository` (Task 6).
- Produces: `appRouter`'s `movieDetails` route (`/movie/:id`) now renders `MovieDetailsScreen`.

- [ ] **Step 1: Update the failing router test**

Replace `test/core/router/app_router_test.dart`:
```dart
import 'dart:async';

import 'package:cinetrack/core/router/app_router.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../helpers/fake_details_repository.dart';
import '../../helpers/fake_discover_repository.dart';

void main() {
  testWidgets('/ shows Discover and pushing /movie/:id shows the details screen', (
    tester,
  ) async {
    final discoverRepository = FakeDiscoverRepository(
      const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
    );
    final detailsRepository = FakeDetailsRepository(
      const Right(
        MovieDetails(
          id: 42,
          title: 'Movie 42',
          overview: 'overview',
          voteAverage: 7,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverRepositoryProvider.overrideWithValue(discoverRepository),
          detailsRepositoryProvider.overrideWithValue(detailsRepository),
        ],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);

    unawaited(appRouter.push('/movie/42'));
    await tester.pumpAndSettle();

    expect(find.text('Movie 42'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: FAIL — `/movie/:id` still shows the old placeholder, not the fetched details title.

- [ ] **Step 3: Delete the old placeholder page**

```bash
rm lib/core/widgets/movie_details_placeholder_page.dart
```

- [ ] **Step 4: Update the router**

In `lib/core/router/app_router.dart`, replace:
```dart
import 'package:cinetrack/core/widgets/movie_details_placeholder_page.dart';
import 'package:cinetrack/core/widgets/stub_page.dart';
import 'package:cinetrack/features/discover/presentation/screens/discover_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'discover',
      builder: (context, state) => const DiscoverScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movieDetails',
      builder: (context, state) => MovieDetailsPlaceholderPage(
        movieId: state.pathParameters['id']!,
      ),
    ),
```
with:
```dart
import 'package:cinetrack/core/widgets/stub_page.dart';
import 'package:cinetrack/features/details/presentation/screens/movie_details_screen.dart';
import 'package:cinetrack/features/discover/presentation/screens/discover_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'discover',
      builder: (context, state) => const DiscoverScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movieDetails',
      builder: (context, state) => MovieDetailsScreen(
        movieId: int.parse(state.pathParameters['id']!),
      ),
    ),
```
(the remaining routes — `/profile`, `/assistant`, `/notifications` — are unchanged; leave them as-is).

- [ ] **Step 5: Run the router test to verify it passes**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS

- [ ] **Step 6: Full verification**

Run: `flutter pub get`
Expected: clean.

Run: `flutter analyze`
Expected: zero issues.

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: zero errors.

Run: `flutter test --dart-define=TMDB_API_KEY=test_key_for_ci`
Expected: all pass (only `dio_client_test.dart` needs the define; everything else uses provider overrides).

- [ ] **Step 7: Commit**

```bash
git add lib/core/router/app_router.dart test/core/router/app_router_test.dart
git rm lib/core/widgets/movie_details_placeholder_page.dart
git commit -m "feat(details): wire MovieDetailsScreen as the /movie/:id route"
```
