// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiscoverNotifier)
final discoverProvider = DiscoverNotifierProvider._();

final class DiscoverNotifierProvider
    extends $AsyncNotifierProvider<DiscoverNotifier, DiscoverState> {
  DiscoverNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverNotifierHash();

  @$internal
  @override
  DiscoverNotifier create() => DiscoverNotifier();
}

String _$discoverNotifierHash() => r'770b130a87d928062500a489259bbbea5b7a3ed5';

abstract class _$DiscoverNotifier extends $AsyncNotifier<DiscoverState> {
  FutureOr<DiscoverState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DiscoverState>, DiscoverState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiscoverState>, DiscoverState>,
              AsyncValue<DiscoverState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
