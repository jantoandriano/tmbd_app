// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(genreMap)
final genreMapProvider = GenreMapProvider._();

final class GenreMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, String>>,
          Map<int, String>,
          FutureOr<Map<int, String>>
        >
    with $FutureModifier<Map<int, String>>, $FutureProvider<Map<int, String>> {
  GenreMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genreMapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genreMapHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, String>> create(Ref ref) {
    return genreMap(ref);
  }
}

String _$genreMapHash() => r'8a0311b288ee604f0fc8d6ea2096f47737a649e4';
