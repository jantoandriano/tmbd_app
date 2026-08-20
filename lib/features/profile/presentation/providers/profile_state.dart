import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    required String name,
    required String email,
    @Default(0) int watchedCount,
    @Default(0) int watchlistCount,
    @Default(0) int reviewsCount,
  }) = _ProfileState;
}
