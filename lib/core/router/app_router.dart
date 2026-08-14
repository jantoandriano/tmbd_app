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
