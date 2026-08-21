// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WatchlistNotifier)
final watchlistProvider = WatchlistNotifierProvider._();

final class WatchlistNotifierProvider
    extends $NotifierProvider<WatchlistNotifier, WatchlistState> {
  WatchlistNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistNotifierHash();

  @$internal
  @override
  WatchlistNotifier create() => WatchlistNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchlistState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchlistState>(value),
    );
  }
}

String _$watchlistNotifierHash() => r'a9bb305075f728eea38a88a44b0081af1e0d5455';

abstract class _$WatchlistNotifier extends $Notifier<WatchlistState> {
  WatchlistState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WatchlistState, WatchlistState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WatchlistState, WatchlistState>,
              WatchlistState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
