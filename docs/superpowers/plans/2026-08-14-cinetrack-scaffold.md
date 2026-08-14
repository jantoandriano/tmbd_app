# CineTrack Scaffold Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Architecture/tooling scaffold for CineTrack (TMDB movie/TV catalog app) — no feature logic.

**Architecture:** Clean-ish layered app: `core/` (network, di, router, theme, utils, errors) + `features/*/{data,domain,presentation}` (empty stubs) + `config/` (env, flavors). DI via get_it+injectable, nav via go_router, state via riverpod, networking via dio, models via freezed/json_serializable, Result via fpdart Either.

**Tech Stack:** flutter_riverpod 3.x, riverpod_annotation/generator, go_router, get_it, injectable(+generator), dio, freezed, json_serializable, flutter_secure_storage, hive(+hive_flutter, hive_generator), fpdart, very_good_analysis, mocktail, integration_test, build_runner.

**Spec:** user-supplied prompt (2026-08-14) — see conversation. Org: `com.cinetrack.app`, app name: CineTrack. Existing dir `D:\Projects\tmbd_app` already has a default `flutter create` scaffold (org `com.example`) — must be regenerated with correct org before anything else.

## Global Constraints
- No feature logic: discover/search/details/auth/watchlist screens stay empty stubs.
- `flutter pub get`, `flutter analyze`, `flutter test` must pass clean at the end.
- `dart run build_runner build --delete-conflicting-outputs` must succeed with zero errors.
- App must launch to placeholder home route ("CineTrack — setup complete") with no crash.
- TMDB_API_KEY read only via `--dart-define`; missing key = clear startup failure, not silent default.

---

## Task 1: Regenerate project with correct org/name

**Files:** whole repo (flutter create overwrite in place)

- [ ] Run `flutter create --org com.cinetrack --project-name cinetrack --platforms android,ios .` from `D:\Projects\tmbd_app`
- [ ] Verify `android/app/build.gradle.kts` now has `applicationId = "com.cinetrack.app"`
- [ ] Verify iOS `PRODUCT_BUNDLE_IDENTIFIER` now `com.cinetrack.app`
- [ ] `flutter pub get` succeeds
- [ ] Commit: `git add -A && git commit -m "chore: regenerate project with cinetrack org"`

## Task 2: Add dependencies

**Files:** `pubspec.yaml`

- [ ] `flutter pub add flutter_riverpod riverpod_annotation go_router get_it injectable dio freezed_annotation json_annotation flutter_secure_storage hive hive_flutter fpdart`
- [ ] `flutter pub add -d riverpod_generator injectable_generator json_serializable freezed build_runner mocktail very_good_analysis hive_generator`
- [ ] `flutter pub add -d integration_test --sdk flutter`
- [ ] Confirm `flutter_riverpod` resolved to `^3.x` in `pubspec.lock` (if not, pin `flutter_riverpod: ^3.0.0` in pubspec.yaml manually and re-run `flutter pub get`)
- [ ] `flutter pub get` clean, no version conflicts
- [ ] Commit: `git add pubspec.yaml pubspec.lock && git commit -m "chore: add core dependencies"`

## Task 3: Folder structure

**Files:** create empty dirs with `.gitkeep`-style placeholder comment files where needed so git tracks empty dirs.

- [ ] Create `lib/core/{constants,errors,network,router,theme,utils,widgets,di}/`
- [ ] Create `lib/features/{discover,search,details,auth,watchlist}/{data,domain,presentation}/` — each leaf gets a `.gitkeep` (git doesn't track empty dirs)
- [ ] Create `lib/l10n/`
- [ ] Create `lib/config/env/` and `lib/config/flavors.dart` (content in Task 8)
- [ ] Commit: `git add -A && git commit -m "chore: scaffold folder structure"`

## Task 4: analysis_options.yaml

**Files:** Modify `analysis_options.yaml`

- [ ] Replace contents:
```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.gr.dart"

linter:
  rules:
    public_member_api_docs: false
```
- [ ] `flutter analyze` runs (will still flag default `main.dart` — fixed in later tasks)
- [ ] Commit: `git add analysis_options.yaml && git commit -m "chore: adopt very_good_analysis"`

## Task 5: core/utils/result.dart (fpdart Either wrapper)

**Files:**
- Create: `lib/core/errors/failure.dart`
- Create: `lib/core/utils/result.dart`

**Interfaces:**
- Produces: `Failure` sealed class (base for future feature-specific failures), `typedef Result<T> = Either<Failure, T>` used by all future repositories.

- [ ] `lib/core/errors/failure.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.server(String message, {int? statusCode}) = ServerFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}
```
- [ ] `lib/core/utils/result.dart`:
```dart
import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';

/// Standard return type for repository methods: `Left(Failure)` on error,
/// `Right(T)` on success.
typedef Result<T> = Either<Failure, T>;
```
- [ ] Commit: `git add lib/core/errors lib/core/utils && git commit -m "feat: add Failure and Result core types"`

## Task 6: core/network — dio client + interceptors

**Files:**
- Create: `lib/core/network/dio_client.dart`
- Create: `lib/core/network/logging_interceptor.dart`
- Create: `lib/core/network/auth_interceptor.dart`
- Create: `lib/core/constants/api_constants.dart`

**Interfaces:**
- Produces: `Dio` instance built by `DioClient.create(baseUrl: ...)`, registered into DI in Task 7.

- [ ] `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  const ApiConstants._();

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
```
- [ ] `lib/core/network/logging_interceptor.dart`:
```dart
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Logs outgoing requests and incoming responses/errors for debugging.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '--> ${options.method} ${options.uri}',
      name: 'DioClient',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    developer.log(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      name: 'DioClient',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}',
      name: 'DioClient',
    );
    handler.next(err);
  }
}
```
- [ ] `lib/core/network/auth_interceptor.dart`:
```dart
import 'package:dio/dio.dart';

/// Placeholder for future auth-token injection (TMDB session id / account
/// auth). No-ops until the auth feature is implemented.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}
```
- [ ] `lib/core/network/dio_client.dart`:
```dart
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Builds the [Dio] instance shared by all repositories.
class DioClient {
  const DioClient._();

  static Dio create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
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
- [ ] `flutter analyze lib/core/network lib/core/constants` clean
- [ ] Commit: `git add lib/core/network lib/core/constants && git commit -m "feat: add dio client with logging and auth interceptors"`

## Task 7: config/env + config/flavors.dart

**Files:**
- Create: `lib/config/env/env_config.dart`
- Create: `lib/config/flavors.dart`

**Interfaces:**
- Produces: `EnvConfig.tmdbApiKey` (throws `StateError` if empty), `Flavor` enum + `FlavorConfig` used by `bootstrap.dart` (Task 10).

- [ ] `lib/config/env/env_config.dart`:
```dart
/// Reads build-time config injected via `--dart-define`.
///
/// TMDB key must be supplied at build/run time, e.g.:
/// `flutter run --dart-define=TMDB_API_KEY=your_key_here`
class EnvConfig {
  const EnvConfig._();

  static const String _tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  static String get tmdbApiKey {
    if (_tmdbApiKey.isEmpty) {
      throw StateError(
        'TMDB_API_KEY is missing. Run with '
        '--dart-define=TMDB_API_KEY=your_key_here',
      );
    }
    return _tmdbApiKey;
  }
}
```
- [ ] `lib/config/flavors.dart`:
```dart
enum Flavor { dev, prod }

/// Holds the active [Flavor] and any flavor-specific values.
///
/// Only `dev` is wired to a real entrypoint today; `prod` is scaffolding
/// for when a separate release configuration is needed.
class FlavorConfig {
  FlavorConfig._({required this.flavor, required this.appName});

  static FlavorConfig? _instance;

  final Flavor flavor;
  final String appName;

  static FlavorConfig get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError('FlavorConfig not initialized. Call FlavorConfig.init first.');
    }
    return instance;
  }

  static FlavorConfig init({required Flavor flavor, required String appName}) {
    final config = FlavorConfig._(flavor: flavor, appName: appName);
    _instance = config;
    return config;
  }

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isProd => instance.flavor == Flavor.prod;
}
```
- [ ] `flutter analyze lib/config` clean
- [ ] Commit: `git add lib/config && git commit -m "feat: add env config and flavor scaffolding"`

## Task 8: core/theme — Material 3 light/dark

**Files:** Create `lib/core/theme/app_theme.dart`

- [ ] `lib/core/theme/app_theme.dart`:
```dart
import 'package:flutter/material.dart';

/// Basic Material 3 theming. Structural placeholder — not visually polished.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      );
}
```
- [ ] `flutter analyze lib/core/theme` clean
- [ ] Commit: `git add lib/core/theme && git commit -m "feat: add Material 3 light/dark theme"`

## Task 9: core/router — go_router with placeholder home

**Files:**
- Create: `lib/core/router/app_router.dart`
- Create: `lib/core/widgets/placeholder_home_page.dart`

**Interfaces:**
- Produces: `appRouter` (GoRouter instance) consumed by `main.dart` (Task 11).

- [ ] `lib/core/widgets/placeholder_home_page.dart`:
```dart
import 'package:flutter/material.dart';

/// Proves the app shell (DI + router + theme) compiles and renders.
/// Replaced by the real discover/home screen in a future pass.
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'CineTrack — setup complete',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
```
- [ ] `lib/core/router/app_router.dart`:
```dart
import 'package:go_router/go_router.dart';

import '../widgets/placeholder_home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const PlaceholderHomePage(),
    ),
  ],
);
```
- [ ] `flutter analyze lib/core/router lib/core/widgets` clean
- [ ] Commit: `git add lib/core/router lib/core/widgets && git commit -m "feat: add go_router with placeholder home route"`

## Task 10: core/di — get_it + injectable bootstrap

**Files:**
- Create: `lib/core/di/injection.dart`
- Create: `lib/core/di/injection.config.dart` (generated in Task 12, do not hand-write)
- Create: `lib/core/di/register_module.dart`

**Interfaces:**
- Consumes: `DioClient.create` (Task 6), `ApiConstants.tmdbBaseUrl` (Task 6).
- Produces: `getIt` (GetIt instance), `configureDependencies()` called from `bootstrap.dart` (Task 11).

- [ ] `lib/core/di/register_module.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../constants/api_constants.dart';
import '../network/dio_client.dart';

/// Registers third-party/manually-constructed instances that injectable
/// can't build via its own `@injectable` annotations.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient.create(baseUrl: ApiConstants.tmdbBaseUrl);
}
```
- [ ] `lib/core/di/injection.dart`:
```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
```
- [ ] Note: `injection.config.dart` does not exist yet — that's expected, it's generated in Task 12. `flutter analyze` will show an error on this file until then; that's fine at this checkpoint.
- [ ] Commit: `git add lib/core/di && git commit -m "feat: add get_it/injectable DI scaffolding"`

## Task 11: bootstrap.dart + main.dart

**Files:**
- Create: `lib/bootstrap.dart`
- Modify: `lib/main.dart` (replace default counter app entirely)

**Interfaces:**
- Consumes: `configureDependencies()` (Task 10), `appRouter` (Task 9), `AppTheme` (Task 8), `EnvConfig.tmdbApiKey` (Task 7), `FlavorConfig.init` (Task 7).

- [ ] `lib/bootstrap.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/env/env_config.dart';
import 'config/flavors.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Shared startup sequence for every flavor entrypoint.
///
/// Validates required env config, wires DI, and runs the app. Throws (and
/// crashes intentionally) if TMDB_API_KEY was not supplied — a broken build
/// should fail loudly at startup, not silently hit TMDB with no key.
Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.init(flavor: flavor, appName: 'CineTrack');

  // Fails fast if --dart-define=TMDB_API_KEY=... was not provided.
  EnvConfig.tmdbApiKey;

  await configureDependencies();

  runApp(
    const ProviderScope(
      child: CineTrackApp(),
    ),
  );
}

class CineTrackApp extends StatelessWidget {
  const CineTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineTrack',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
```
- [ ] `lib/main.dart` (full replace):
```dart
import 'bootstrap.dart';
import 'config/flavors.dart';

Future<void> main() async {
  await bootstrap(flavor: Flavor.dev);
}
```
- [ ] Delete now-orphaned default `test/widget_test.dart` counter test (replaced in Task 13)
- [ ] Commit: `git add lib/bootstrap.dart lib/main.dart && git rm test/widget_test.dart && git commit -m "feat: wire bootstrap, DI, router, theme into app shell"`

## Task 12: Run code generation

**Files:** none new — generates `*.freezed.dart`, `*.g.dart`, `injection.config.dart`

- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] Expected: exits 0, produces `lib/core/errors/failure.freezed.dart` and `lib/core/di/injection.config.dart`
- [ ] Commit: `git add -A && git commit -m "chore: run build_runner codegen"`

## Task 13: Smoke test

**Files:** Create `test/app_smoke_test.dart`

- [ ] `test/app_smoke_test.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinetrack/bootstrap.dart';
import 'package:cinetrack/core/di/injection.dart';

void main() {
  testWidgets('renders placeholder home route', (tester) async {
    await configureDependencies();

    await tester.pumpWidget(
      const ProviderScope(child: CineTrackApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('CineTrack — setup complete'), findsOneWidget);
  });
}
```
- [ ] Run: `flutter test --dart-define=TMDB_API_KEY=test_key_for_ci`
- [ ] Expected: PASS
- [ ] Commit: `git add test/app_smoke_test.dart && git commit -m "test: add app shell smoke test"`

## Task 14: Final verification pass

- [ ] `flutter pub get` — clean
- [ ] `flutter analyze` — zero issues
- [ ] `dart run build_runner build --delete-conflicting-outputs` — zero errors
- [ ] `flutter test --dart-define=TMDB_API_KEY=test_key_for_ci` — all pass
- [ ] `flutter run --dart-define=TMDB_API_KEY=test_key_for_ci` (or `flutter run -d chrome ...` if no device) — confirm app launches to "CineTrack — setup complete", no crash; stop the run
- [ ] Confirm without `--dart-define=TMDB_API_KEY=...`, `flutter run` fails fast with the `StateError` message (manual check, don't leave it running)
