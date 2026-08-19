// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiOverviewSummary)
final aiOverviewSummaryProvider = AiOverviewSummaryFamily._();

final class AiOverviewSummaryProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  AiOverviewSummaryProvider._({
    required AiOverviewSummaryFamily super.from,
    required MovieDetails super.argument,
  }) : super(
         retry: null,
         name: r'aiOverviewSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiOverviewSummaryHash();

  @override
  String toString() {
    return r'aiOverviewSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as MovieDetails;
    return aiOverviewSummary(ref, movie: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AiOverviewSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiOverviewSummaryHash() => r'f0a9e888beec8834bf7770c494fe180c3ed82c7d';

final class AiOverviewSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, MovieDetails> {
  AiOverviewSummaryFamily._()
    : super(
        retry: null,
        name: r'aiOverviewSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AiOverviewSummaryProvider call({required MovieDetails movie}) =>
      AiOverviewSummaryProvider._(argument: movie, from: this);

  @override
  String toString() => r'aiOverviewSummaryProvider';
}
