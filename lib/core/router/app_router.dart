import 'package:cinetrack/core/widgets/stub_page.dart';
import 'package:cinetrack/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:cinetrack/features/details/presentation/screens/movie_details_screen.dart';
import 'package:cinetrack/features/discover/presentation/screens/discover_screen.dart';
import 'package:cinetrack/features/discover/presentation/screens/movie_list_screen.dart';
import 'package:cinetrack/features/profile/presentation/screens/profile_screen.dart';
import 'package:cinetrack/features/watchlist/presentation/screens/watchlist_screen.dart';
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
      builder: (context, state) => MovieDetailsScreen(
        movieId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/movie-list',
      name: 'movieList',
      builder: (context, state) =>
          MovieListScreen(args: state.extra! as MovieListArgs),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/watchlist',
      name: 'watchlist',
      builder: (context, state) => const WatchlistScreen(),
    ),
    GoRoute(
      path: '/assistant',
      name: 'assistant',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const StubPage(title: 'Notifications'),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const StubPage(title: 'Settings'),
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'editProfile',
      builder: (context, state) => const StubPage(title: 'Edit Profile'),
    ),
    GoRoute(
      path: '/account',
      name: 'account',
      builder: (context, state) => const StubPage(title: 'Account'),
    ),
    GoRoute(
      path: '/payment-methods',
      name: 'paymentMethods',
      builder: (context, state) => const StubPage(title: 'Payment Methods'),
    ),
    GoRoute(
      path: '/help-support',
      name: 'helpSupport',
      builder: (context, state) => const StubPage(title: 'Help & Support'),
    ),
  ],
);
