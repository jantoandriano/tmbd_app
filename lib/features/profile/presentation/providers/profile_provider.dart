import 'package:cinetrack/features/profile/presentation/providers/profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() => const ProfileState(
    name: 'Alex Rivera',
    email: 'alex.rivera@email.com',
    watchedCount: 128,
    reviewsCount: 16,
  );
}
