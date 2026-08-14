# Discover Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Paginated grid of TMDB's popular movies, infinite-scrolling, as the app's home screen — the first real feature on the CineTrack scaffold.

**Architecture:** Clean-ish layers per feature: `domain` (entities + repository interface, no deps on Flutter/Dio), `data` (Dio-backed datasource + repository impl, returns `Result<T>`), `presentation` (riverpod_generator `AsyncNotifier` + widgets). `get_it` stays owner of `Dio`; Riverpod owns the feature's own provider graph on top of it.

**Tech Stack:** dio, flutter_riverpod + riverpod_generator, fpdart (`Either`/`Result`), freezed + json_serializable, go_router, cached_network_image (new), mocktail (tests).

**Spec:** `docs/superpowers/specs/2026-08-14-discover-feature-design.md` — read it alongside this plan; it has the full rationale (why no usecase layer, why next-page failures don't clobber state, the DI bridge reasoning).

## Global Constraints

- All imports use `package:cinetrack/...` — relative imports fail `very_good_analysis`'s `always_use_package_imports` lint.
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors after every task that adds `@freezed`/`@JsonSerializable`/`@riverpod` code.
- `flutter analyze` must report zero issues after every task.
- Repository methods return `Result<T>` (`typedef Result<T> = Either<Failure, T>` from `lib/core/utils/result.dart`) — never throw past the data layer boundary (the *datasource* may throw `DioException`; the *repository* catches it).
- Tests that exercise `DioClient.create()` directly need `--dart-define=TMDB_API_KEY=test_key_for_ci`; tests that override `discoverRepositoryProvider` do not (the override short-circuits before `Dio` is ever touched).
- No new dependency beyond `cached_network_image`.

---

## Task 1: TMDB API key wiring + image base URL constant

**Files:**
- Modify: `lib/core/network/dio_client.dart`
- Modify: `lib/core/constants/api_constants.dart`
- Test: `test/core/network/dio_client_test.dart`

**Interfaces:**
- Produces: `ApiConstants.tmdbImageBaseUrl` (`String`), used by `MovieGridItem` in Task 6.

- [ ] **Step 1: Add the `cached_network_image` dependency**

Run: `flutter pub add cached_network_image`

- [ ] **Step 2: Write the failing test**

`test/core/network/dio_client_test.dart`:
```dart
import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create sets the TMDB api_key as a default query parameter', () {
    final dio = DioClient.create(baseUrl: 'https://api.themoviedb.org/3');

    expect(dio.options.queryParameters['api_key'], EnvConfig.tmdbApiKey);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/network/dio_client_test.dart --dart-define=TMDB_API_KEY=test_key_for_ci`
Expected: FAIL — `dio.options.queryParameters['api_key']` is `null`, not `'test_key_for_ci'`.

- [ ] **Step 3: Add the image base URL constant**

In `lib/core/constants/api_constants.dart`, add alongside the existing members:
```dart
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
```

- [ ] **Step 4: Wire the api_key default query parameter**

In `lib/core/network/dio_client.dart`, add the import and the `queryParameters` entry:
```dart
import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/network/auth_interceptor.dart';
import 'package:cinetrack/core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';

/// Builds the [Dio] instance shared by all repositories.
class DioClient {
  const DioClient._();

  static Dio create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {'api_key': EnvConfig.tmdbApiKey},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/core/network/dio_client_test.dart --dart-define=TMDB_API_KEY=test_key_for_ci`
Expected: PASS

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/network/dio_client.dart lib/core/constants/api_constants.dart test/core/network/dio_client_test.dart
git commit -m "feat(discover): wire TMDB api_key into DioClient, add image base URL"
```

---

## Task 2: Domain entities and data models

**Files:**
- Create: `lib/features/discover/domain/entities/movie.dart`
- Create: `lib/features/discover/domain/entities/paginated_movies.dart`
- Create: `lib/features/discover/data/models/movie_model.dart`
- Create: `lib/features/discover/data/models/movie_page_response_model.dart`
- Test: `test/features/discover/data/models/movie_model_test.dart`
- Test: `test/features/discover/data/models/movie_page_response_model_test.dart`
- Delete: `lib/features/discover/domain/placeholder.dart`, `lib/features/discover/data/placeholder.dart`

**Interfaces:**
- Produces: `Movie` (domain entity: `id`, `title`, `posterPath` (nullable), `voteAverage`, `releaseDate` (nullable), `overview`), `PaginatedMovies` (`movies`, `page`, `totalPages`), `MovieModel.toEntity() -> Movie`, `MoviePageResponseModel` (`page`, `results: List<MovieModel>`, `totalPages`). Consumed by Task 3 (datasource), Task 4 (repository), Task 5 (notifier), Task 6/7 (widgets).

`PaginatedMovies` has no test of its own in this task — it's a plain value holder with no logic; its field construction is exercised by Task 4's repository tests and Task 5's notifier tests.

- [ ] **Step 1: Remove the placeholder files**

```bash
rm lib/features/discover/domain/placeholder.dart lib/features/discover/data/placeholder.dart
```

- [ ] **Step 2: Write the domain entities**

`lib/features/discover/domain/entities/movie.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

@freezed
sealed class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    String? posterPath,
    required double voteAverage,
    String? releaseDate,
    required String overview,
  }) = _Movie;
}
```

`lib/features/discover/domain/entities/paginated_movies.dart`:
```dart
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_movies.freezed.dart';

@freezed
sealed class PaginatedMovies with _$PaginatedMovies {
  const factory PaginatedMovies({
    required List<Movie> movies,
    required int page,
    required int totalPages,
  }) = _PaginatedMovies;
}
```

- [ ] **Step 3: Write the failing model tests**

`test/features/discover/data/models/movie_model_test.dart`:
```dart
import 'package:cinetrack/features/discover/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = <String, dynamic>{
    'id': 550,
    'title': 'Fight Club',
    'poster_path': '/poster.jpg',
    'vote_average': 8.4,
    'release_date': '1999-10-15',
    'overview': 'An insomniac office worker...',
  };

  test('fromJson maps TMDB snake_case fields', () {
    final model = MovieModel.fromJson(json);

    expect(model.id, 550);
    expect(model.title, 'Fight Club');
    expect(model.posterPath, '/poster.jpg');
    expect(model.voteAverage, 8.4);
    expect(model.releaseDate, '1999-10-15');
    expect(model.overview, 'An insomniac office worker...');
  });

  test('toEntity maps to the domain Movie', () {
    final entity = MovieModel.fromJson(json).toEntity();

    expect(entity.id, 550);
    expect(entity.title, 'Fight Club');
    expect(entity.posterPath, '/poster.jpg');
    expect(entity.voteAverage, 8.4);
    expect(entity.releaseDate, '1999-10-15');
    expect(entity.overview, 'An insomniac office worker...');
  });
}
```

`test/features/discover/data/models/movie_page_response_model_test.dart`:
```dart
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson maps page, results, and total_pages', () {
    final json = <String, dynamic>{
      'page': 1,
      'results': <Map<String, dynamic>>[
        {
          'id': 1,
          'title': 'A',
          'poster_path': null,
          'vote_average': 5.0,
          'release_date': null,
          'overview': '',
        },
      ],
      'total_pages': 500,
      'total_results': 10000,
    };

    final model = MoviePageResponseModel.fromJson(json);

    expect(model.page, 1);
    expect(model.results, hasLength(1));
    expect(model.results.first.title, 'A');
    expect(model.totalPages, 500);
  });
}
```

- [ ] **Step 4: Run tests to verify they fail**

Run: `flutter test test/features/discover/data/models/`
Expected: FAIL to compile — `MovieModel`/`MoviePageResponseModel` don't exist yet.

- [ ] **Step 5: Write the data models**

`lib/features/discover/data/models/movie_model.dart`:
```dart
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
sealed class MovieModel with _$MovieModel {
  const MovieModel._();

  const factory MovieModel({
    required int id,
    required String title,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'release_date') String? releaseDate,
    required String overview,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Movie toEntity() => Movie(
    id: id,
    title: title,
    posterPath: posterPath,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
    overview: overview,
  );
}
```

`lib/features/discover/data/models/movie_page_response_model.dart`:
```dart
import 'package:cinetrack/features/discover/data/models/movie_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_page_response_model.freezed.dart';
part 'movie_page_response_model.g.dart';

@freezed
sealed class MoviePageResponseModel with _$MoviePageResponseModel {
  const factory MoviePageResponseModel({
    required int page,
    required List<MovieModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _MoviePageResponseModel;

  factory MoviePageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviePageResponseModelFromJson(json);
}
```

- [ ] **Step 6: Generate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Succeeds, no errors.

- [ ] **Step 7: Run tests to verify they pass**

Run: `flutter test test/features/discover/data/models/`
Expected: PASS

- [ ] **Step 8: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 9: Commit**

```bash
git add lib/features/discover/domain/entities lib/features/discover/data/models test/features/discover/data/models
git rm lib/features/discover/domain/placeholder.dart lib/features/discover/data/placeholder.dart
git commit -m "feat(discover): add Movie/PaginatedMovies entities and MovieModel/MoviePageResponseModel"
```

---

## Task 3: DiscoverRemoteDataSource

**Files:**
- Create: `lib/features/discover/data/datasources/discover_remote_data_source.dart`
- Test: `test/features/discover/data/datasources/discover_remote_data_source_test.dart`

**Interfaces:**
- Consumes: `Dio` (constructor param), `MoviePageResponseModel.fromJson` (Task 2).
- Produces: `abstract class DiscoverRemoteDataSource { Future<MoviePageResponseModel> fetchPopularMovies({required int page}); }`, `DiscoverRemoteDataSourceImpl(Dio dio)`. Consumed by Task 4 (repository).

- [ ] **Step 1: Write the failing tests**

`test/features/discover/data/datasources/discover_remote_data_source_test.dart`:
```dart
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DiscoverRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = DiscoverRemoteDataSourceImpl(dio);
  });

  test('fetchPopularMovies decodes the response into MoviePageResponseModel', () async {
    final json = <String, dynamic>{
      'page': 1,
      'results': <Map<String, dynamic>>[],
      'total_pages': 500,
      'total_results': 10000,
    };

    when(
      () => dio.get<Map<String, dynamic>>(
        '/movie/popular',
        queryParameters: {'page': 1},
      ),
    ).thenAnswer(
      (_) async => Response(
        data: json,
        requestOptions: RequestOptions(path: '/movie/popular'),
      ),
    );

    final result = await dataSource.fetchPopularMovies(page: 1);

    expect(result, isA<MoviePageResponseModel>());
    expect(result.page, 1);
    expect(result.totalPages, 500);
  });

  test('fetchPopularMovies lets DioException propagate', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        '/movie/popular',
        queryParameters: {'page': 1},
      ),
    ).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/movie/popular')),
    );

    expect(
      () => dataSource.fetchPopularMovies(page: 1),
      throwsA(isA<DioException>()),
    );
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/discover/data/datasources/`
Expected: FAIL to compile — `DiscoverRemoteDataSource`/`DiscoverRemoteDataSourceImpl` don't exist yet.

- [ ] **Step 3: Write the datasource**

`lib/features/discover/data/datasources/discover_remote_data_source.dart`:
```dart
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:dio/dio.dart';

abstract class DiscoverRemoteDataSource {
  /// Throws [DioException] on failure — the repository is responsible for
  /// catching it and converting it to a domain-level failure.
  Future<MoviePageResponseModel> fetchPopularMovies({required int page});
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  DiscoverRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MoviePageResponseModel> fetchPopularMovies({required int page}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/popular',
      queryParameters: {'page': page},
    );
    return MoviePageResponseModel.fromJson(response.data!);
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/discover/data/datasources/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/discover/data/datasources test/features/discover/data/datasources
git commit -m "feat(discover): add DiscoverRemoteDataSource"
```

---

## Task 4: DiscoverRepository

**Files:**
- Create: `lib/features/discover/domain/repositories/discover_repository.dart`
- Create: `lib/features/discover/data/repositories/discover_repository_impl.dart`
- Test: `test/features/discover/data/repositories/discover_repository_impl_test.dart`

**Interfaces:**
- Consumes: `DiscoverRemoteDataSource` (Task 3), `Result<T>` / `Failure` (`lib/core/utils/result.dart`, `lib/core/errors/failure.dart`), `PaginatedMovies` (Task 2).
- Produces: `abstract class DiscoverRepository { Future<Result<PaginatedMovies>> getPopularMovies({required int page}); }`, `DiscoverRepositoryImpl(DiscoverRemoteDataSource)`. Consumed by Task 5 (notifier), Task 7/8 (test overrides).

- [ ] **Step 1: Write the failing tests**

`test/features/discover/data/repositories/discover_repository_impl_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/models/movie_page_response_model.dart';
import 'package:cinetrack/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoverRemoteDataSource extends Mock
    implements DiscoverRemoteDataSource {}

void main() {
  late MockDiscoverRemoteDataSource dataSource;
  late DiscoverRepositoryImpl repository;

  setUp(() {
    dataSource = MockDiscoverRemoteDataSource();
    repository = DiscoverRepositoryImpl(dataSource);
  });

  test('returns Right(PaginatedMovies) on success', () async {
    when(() => dataSource.fetchPopularMovies(page: 1)).thenAnswer(
      (_) async => const MoviePageResponseModel(
        page: 1,
        results: [],
        totalPages: 500,
      ),
    );

    final result = await repository.getPopularMovies(page: 1);

    expect(result.isRight(), isTrue);
    result.match(
      (l) => fail('expected Right, got Left($l)'),
      (r) {
        expect(r.page, 1);
        expect(r.totalPages, 500);
      },
    );
  });

  test('returns Left(ServerFailure) when DioException carries a response', () async {
    when(() => dataSource.fetchPopularMovies(page: 1)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/movie/popular'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/movie/popular'),
        ),
      ),
    );

    final result = await repository.getPopularMovies(page: 1);

    expect(result.isLeft(), isTrue);
    result.match(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('expected Left, got Right($r)'),
    );
  });

  test('returns Left(NetworkFailure) when DioException has no response', () async {
    when(() => dataSource.fetchPopularMovies(page: 1)).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/movie/popular')),
    );

    final result = await repository.getPopularMovies(page: 1);

    result.match(
      (l) => expect(l, isA<NetworkFailure>()),
      (r) => fail('expected Left, got Right($r)'),
    );
  });

  test('returns Left(UnexpectedFailure) on a non-Dio exception', () async {
    when(
      () => dataSource.fetchPopularMovies(page: 1),
    ).thenThrow(Exception('boom'));

    final result = await repository.getPopularMovies(page: 1);

    result.match(
      (l) => expect(l, isA<UnexpectedFailure>()),
      (r) => fail('expected Left, got Right($r)'),
    );
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/discover/data/repositories/`
Expected: FAIL to compile — `DiscoverRepository`/`DiscoverRepositoryImpl` don't exist yet.

- [ ] **Step 3: Write the repository interface and implementation**

`lib/features/discover/domain/repositories/discover_repository.dart`:
```dart
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';

abstract class DiscoverRepository {
  Future<Result<PaginatedMovies>> getPopularMovies({required int page});
}
```

`lib/features/discover/data/repositories/discover_repository_impl.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/core/utils/result.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  DiscoverRepositoryImpl(this._remoteDataSource);

  final DiscoverRemoteDataSource _remoteDataSource;

  @override
  Future<Result<PaginatedMovies>> getPopularMovies({required int page}) async {
    try {
      final response = await _remoteDataSource.fetchPopularMovies(page: page);
      return Right(
        PaginatedMovies(
          movies: response.results.map((m) => m.toEntity()).toList(),
          page: response.page,
          totalPages: response.totalPages,
        ),
      );
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
    } catch (e) {
      return Left(Failure.unexpected(e.toString()));
    }
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/discover/data/repositories/`
Expected: PASS

- [ ] **Step 5: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/discover/domain/repositories lib/features/discover/data/repositories test/features/discover/data/repositories
git commit -m "feat(discover): add DiscoverRepository"
```

---

## Task 5: DI providers, DiscoverState, and DiscoverNotifier

**Files:**
- Create: `lib/features/discover/presentation/providers/discover_di.dart`
- Create: `lib/features/discover/presentation/providers/discover_state.dart`
- Create: `lib/features/discover/presentation/providers/discover_provider.dart`
- Test: `test/features/discover/presentation/providers/discover_provider_test.dart`

**Interfaces:**
- Consumes: `DiscoverRepository` (Task 4), `getIt<Dio>()` (`lib/core/di/injection.dart`).
- Produces: `discoverRepositoryProvider` (`Provider<DiscoverRepository>`), `discoverNotifierProvider` (generated, `AsyncNotifierProvider<DiscoverNotifier, DiscoverState>`), `DiscoverState` (`movies`, `page`, `hasReachedMax`, `isLoadingMore`), `DiscoverNotifier.loadNextPage() -> Future<Failure?>`. Consumed by Task 6 (screen), Task 7 (screen test overrides).

- [ ] **Step 1: Write the DI wiring (no test — trivial composition, exercised by the notifier tests below)**

`lib/features/discover/presentation/providers/discover_di.dart`:
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

final discoverRepositoryProvider = Provider<DiscoverRepository>(
  (ref) =>
      DiscoverRepositoryImpl(ref.watch(discoverRemoteDataSourceProvider)),
);
```

- [ ] **Step 2: Write the state class**

`lib/features/discover/presentation/providers/discover_state.dart`:
```dart
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_state.freezed.dart';

@freezed
sealed class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = _DiscoverState;
}
```

- [ ] **Step 3: Write the failing notifier tests**

`test/features/discover/presentation/providers/discover_provider_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  voteAverage: 7,
  releaseDate: '2024-01-01',
  overview: 'overview',
);

void main() {
  late MockDiscoverRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockDiscoverRepository();
    container = ProviderContainer(
      overrides: [discoverRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(container.dispose);

  test('build loads page 1 into state', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 5)),
    );

    final state = await container.read(discoverNotifierProvider.future);

    expect(state.movies, hasLength(1));
    expect(state.hasReachedMax, isFalse);
  });

  test('build surfaces a repository failure as an AsyncError', () async {
    when(
      () => repository.getPopularMovies(page: 1),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    await expectLater(
      container.read(discoverNotifierProvider.future),
      throwsA(isA<Failure>()),
    );
  });

  test('loadNextPage appends movies and advances the page', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 2)),
    );
    when(() => repository.getPopularMovies(page: 2)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(2)], page: 2, totalPages: 2)),
    );

    await container.read(discoverNotifierProvider.future);
    final failure = await container
        .read(discoverNotifierProvider.notifier)
        .loadNextPage();

    final state = container.read(discoverNotifierProvider).value!;
    expect(failure, isNull);
    expect(state.movies, hasLength(2));
    expect(state.page, 2);
    expect(state.hasReachedMax, isTrue);
  });

  test('loadNextPage failure leaves existing movies untouched', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 5)),
    );
    when(
      () => repository.getPopularMovies(page: 2),
    ).thenAnswer((_) async => const Left(Failure.network('offline')));

    await container.read(discoverNotifierProvider.future);
    final failure = await container
        .read(discoverNotifierProvider.notifier)
        .loadNextPage();

    final state = container.read(discoverNotifierProvider).value!;
    expect(failure, isA<NetworkFailure>());
    expect(state.movies, hasLength(1));
    expect(state.isLoadingMore, isFalse);
  });

  test('loadNextPage is a no-op once hasReachedMax is true', () async {
    when(() => repository.getPopularMovies(page: 1)).thenAnswer(
      (_) async =>
          Right(PaginatedMovies(movies: [_movie(1)], page: 1, totalPages: 1)),
    );

    await container.read(discoverNotifierProvider.future);
    final failure = await container
        .read(discoverNotifierProvider.notifier)
        .loadNextPage();

    expect(failure, isNull);
    verifyNever(() => repository.getPopularMovies(page: 2));
  });
}
```

- [ ] **Step 4: Run tests to verify they fail**

Run: `flutter test test/features/discover/presentation/providers/`
Expected: FAIL to compile — `discoverNotifierProvider`/`DiscoverNotifier` don't exist yet.

- [ ] **Step 5: Write the notifier**

`lib/features/discover/presentation/providers/discover_provider.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_provider.g.dart';

@riverpod
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
    final current = state.valueOrNull;
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
```

- [ ] **Step 6: Generate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Succeeds, no errors.

- [ ] **Step 7: Run tests to verify they pass**

Run: `flutter test test/features/discover/presentation/providers/`
Expected: PASS

- [ ] **Step 8: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 9: Commit**

```bash
git add lib/features/discover/presentation/providers test/features/discover/presentation/providers
git commit -m "feat(discover): add DiscoverNotifier with pagination"
```

---

## Task 6: MovieGridItem widget

**Files:**
- Create: `lib/features/discover/presentation/widgets/movie_grid_item.dart`
- Test: `test/features/discover/presentation/widgets/movie_grid_item_test.dart`
- Delete: `lib/features/discover/presentation/placeholder.dart`

**Interfaces:**
- Consumes: `Movie` (Task 2), `ApiConstants.tmdbImageBaseUrl` (Task 1).
- Produces: `MovieGridItem({required Movie movie, required VoidCallback onTap})`. Consumed by Task 7 (screen).

- [ ] **Step 1: Remove the placeholder file**

```bash
rm lib/features/discover/presentation/placeholder.dart
```

- [ ] **Step 2: Write the failing tests**

`test/features/discover/presentation/widgets/movie_grid_item_test.dart`:
```dart
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Movie _movie({String? posterPath}) => Movie(
  id: 1,
  title: 'Fight Club',
  posterPath: posterPath,
  voteAverage: 8.4,
  releaseDate: '1999-10-15',
  overview: 'overview',
);

void main() {
  testWidgets('shows a placeholder icon when posterPath is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MovieGridItem(movie: _movie(), onTap: () {}),
      ),
    );

    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    expect(find.text('Fight Club'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MovieGridItem(movie: _movie(), onTap: () => tapped = true),
      ),
    );
    await tester.tap(find.byType(MovieGridItem));

    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/features/discover/presentation/widgets/`
Expected: FAIL to compile — `MovieGridItem` doesn't exist yet.

- [ ] **Step 4: Write the widget**

`lib/features/discover/presentation/widgets/movie_grid_item.dart`:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  const MovieGridItem({required this.movie, required this.onTap, super.key});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: posterPath == null
                ? const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.movie_outlined),
                  )
                : CachedNetworkImage(
                    imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
          ),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/discover/presentation/widgets/`
Expected: PASS

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add lib/features/discover/presentation/widgets test/features/discover/presentation/widgets
git rm lib/features/discover/presentation/placeholder.dart
git commit -m "feat(discover): add MovieGridItem widget"
```

---

## Task 7: DiscoverScreen

**Files:**
- Create: `lib/features/discover/presentation/screens/discover_screen.dart`
- Create: `test/helpers/fake_discover_repository.dart`
- Test: `test/features/discover/presentation/screens/discover_screen_test.dart`

**Interfaces:**
- Consumes: `discoverNotifierProvider`, `DiscoverState` (Task 5), `MovieGridItem` (Task 6), `discoverRepositoryProvider` (Task 5, for test overrides).
- Produces: `DiscoverScreen` (no constructor params). Consumed by Task 8 (router).
- `test/helpers/fake_discover_repository.dart` produces `FakeDiscoverRepository(Result<PaginatedMovies> result)` implementing `DiscoverRepository`, reused by Task 8's router test and the app-level smoke test.

- [ ] **Step 1: Write the shared test fake**

`test/helpers/fake_discover_repository.dart`:
```dart
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
```

- [ ] **Step 2: Write the failing tests**

`test/features/discover/presentation/screens/discover_screen_test.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:cinetrack/features/discover/presentation/screens/discover_screen.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../helpers/fake_discover_repository.dart';

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  voteAverage: 7,
  releaseDate: '2024-01-01',
  overview: 'overview',
);

void main() {
  testWidgets('shows the movie grid when data loads', (tester) async {
    final repository = FakeDiscoverRepository(
      Right(
        PaginatedMovies(movies: [_movie(1), _movie(2)], page: 1, totalPages: 5),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(MovieGridItem), findsNWidgets(2));
  });

  testWidgets('shows an error state with a retry button on failure', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      const Left(Failure.network('offline')),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Something went wrong.'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/features/discover/presentation/screens/`
Expected: FAIL to compile — `DiscoverScreen` doesn't exist yet.

- [ ] **Step 4: Write the screen**

`lib/features/discover/presentation/screens/discover_screen.dart`:
```dart
import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    final failure = await ref
        .read(discoverNotifierProvider.notifier)
        .loadNextPage();
    if (failure != null && mounted) {
      final message = switch (failure) {
        NetworkFailure(:final message) => message,
        ServerFailure(:final message) => message,
        CacheFailure(:final message) => message,
        UnexpectedFailure(:final message) => message,
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(discoverNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (discoverState) => GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount:
              discoverState.movies.length + (discoverState.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= discoverState.movies.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final movie = discoverState.movies[index];
            return MovieGridItem(
              movie: movie,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/discover/presentation/screens/`
Expected: PASS

- [ ] **Step 6: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 7: Commit**

```bash
git add lib/features/discover/presentation/screens test/helpers test/features/discover/presentation/screens
git commit -m "feat(discover): add DiscoverScreen with infinite scroll"
```

---

## Task 8: Routing and app-level smoke test

**Files:**
- Modify: `lib/core/router/app_router.dart`
- Delete: `lib/core/widgets/placeholder_home_page.dart`
- Create: `lib/core/widgets/movie_details_placeholder_page.dart`
- Modify: `test/app_smoke_test.dart`
- Test: `test/core/router/app_router_test.dart`

**Interfaces:**
- Consumes: `DiscoverScreen` (Task 7), `discoverRepositoryProvider` (Task 5), `FakeDiscoverRepository` (Task 7).
- Produces: `appRouter` now has routes `discover` (`/`) and `movieDetails` (`/movie/:id`).

- [ ] **Step 1: Write the failing router test**

`test/core/router/app_router_test.dart`:
```dart
import 'package:cinetrack/core/router/app_router.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../helpers/fake_discover_repository.dart';

void main() {
  testWidgets('/ shows Discover and pushing /movie/:id shows the placeholder', (
    tester,
  ) async {
    final repository = FakeDiscoverRepository(
      const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Discover'), findsOneWidget);

    appRouter.push('/movie/42');
    await tester.pumpAndSettle();

    expect(find.text('Movie 42'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: FAIL — `/` still shows the old placeholder text, `/movie/:id` route doesn't exist.

- [ ] **Step 3: Remove the old placeholder home page**

```bash
rm lib/core/widgets/placeholder_home_page.dart
```

- [ ] **Step 4: Add the movie details placeholder page**

`lib/core/widgets/movie_details_placeholder_page.dart`:
```dart
import 'package:flutter/material.dart';

/// Placeholder for the real movie details screen (a future feature).
/// Proves route + path-parameter passing from the discover grid.
class MovieDetailsPlaceholderPage extends StatelessWidget {
  const MovieDetailsPlaceholderPage({required this.movieId, super.key});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Movie $movieId')),
    );
  }
}
```

- [ ] **Step 5: Update the router**

`lib/core/router/app_router.dart`:
```dart
import 'package:cinetrack/core/widgets/movie_details_placeholder_page.dart';
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
  ],
);
```

- [ ] **Step 6: Run router test to verify it passes**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS

- [ ] **Step 7: Update the app-level smoke test**

`test/app_smoke_test.dart` (full replace — the old placeholder-text assertion no longer applies now that `DiscoverScreen` is the real home screen):
```dart
import 'package:cinetrack/bootstrap.dart';
import 'package:cinetrack/core/di/injection.dart';
import 'package:cinetrack/features/discover/domain/entities/paginated_movies.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'helpers/fake_discover_repository.dart';

void main() {
  testWidgets('renders the discover home screen', (tester) async {
    await configureDependencies();

    final repository = FakeDiscoverRepository(
      const Right(PaginatedMovies(movies: [], page: 1, totalPages: 1)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          discoverRepositoryProvider.overrideWithValue(repository),
        ],
        child: const CineTrackApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Discover'), findsOneWidget);
  });
}
```

- [ ] **Step 8: Run the smoke test to verify it passes**

Run: `flutter test test/app_smoke_test.dart`
Expected: PASS

- [ ] **Step 9: Analyze**

Run: `flutter analyze`
Expected: No issues.

- [ ] **Step 10: Commit**

```bash
git add lib/core/router/app_router.dart lib/core/widgets/movie_details_placeholder_page.dart test/app_smoke_test.dart test/core/router
git rm lib/core/widgets/placeholder_home_page.dart
git commit -m "feat(discover): wire DiscoverScreen as home route, add movie details placeholder route"
```

---

## Task 9: Final verification

- [ ] `flutter pub get` — clean
- [ ] `flutter analyze` — zero issues
- [ ] `dart run build_runner build --delete-conflicting-outputs` — zero errors
- [ ] `flutter test --dart-define=TMDB_API_KEY=test_key_for_ci` — all pass (this covers `dio_client_test.dart`, which is the only test in the suite that needs the define)
- [ ] `flutter build web --dart-define=TMDB_API_KEY=test_key_for_ci` — compiles clean (same verification approach used for the CineTrack scaffold pass, given this sandbox's Windows-desktop ATL gap and headless Chrome debug-connect limitation)
