import 'package:cinetrack/core/widgets/placeholder_home_page.dart';
import 'package:go_router/go_router.dart';

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
