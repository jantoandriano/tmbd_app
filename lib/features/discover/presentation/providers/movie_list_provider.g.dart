// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MovieListNotifier)
final movieListProvider = MovieListNotifierFamily._();

final class MovieListNotifierProvider
    extends $AsyncNotifierProvider<MovieListNotifier, MovieListState> {
  MovieListNotifierProvider._({
    required MovieListNotifierFamily super.from,
    required MovieListType super.argument,
  }) : super(
         retry: null,
         name: r'movieListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movieListNotifierHash();

  @override
  String toString() {
    return r'movieListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MovieListNotifier create() => MovieListNotifier();

  @override
  bool operator ==(Object other) {
    return other is MovieListNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movieListNotifierHash() => r'6f677149dd93281905d428566746c6b449ea5731';

final class MovieListNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MovieListNotifier,
          AsyncValue<MovieListState>,
          MovieListState,
          FutureOr<MovieListState>,
          MovieListType
        > {
  MovieListNotifierFamily._()
    : super(
        retry: null,
        name: r'movieListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovieListNotifierProvider call(MovieListType type) =>
      MovieListNotifierProvider._(argument: type, from: this);

  @override
  String toString() => r'movieListProvider';
}

abstract class _$MovieListNotifier extends $AsyncNotifier<MovieListState> {
  late final _$args = ref.$arg as MovieListType;
  MovieListType get type => _$args;

  FutureOr<MovieListState> build(MovieListType type);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MovieListState>, MovieListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MovieListState>, MovieListState>,
              AsyncValue<MovieListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
