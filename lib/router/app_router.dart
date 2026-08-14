import 'package:go_router/go_router.dart';
import 'package:smart_app/models/movie.dart';
import 'package:smart_app/screens/home_screen.dart';
import 'package:smart_app/screens/movie_detail_screen.dart';
import 'package:smart_app/screens/splash_screen.dart';

/// Nombres de las rutas para usarlos con context.goNamed(...)
abstract class AppRoutes {
  static const splash = 'splash';
  static const home = 'home';
  static const movieDetail = 'movie-detail';
}

/// Paths de las rutas
abstract class AppPaths {
  static const splash = '/';
  static const home = '/home';
  static const movieDetail = '/movie';
}

final appRouter = GoRouter(
  initialLocation: AppPaths.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: AppPaths.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoutes.home,
      path: AppPaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: AppRoutes.movieDetail,
      path: AppPaths.movieDetail,
      // La película se pasa como `extra` ya que es un objeto en memoria (datos mock)
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailScreen(movie: movie);
      },
    ),
  ],
);

