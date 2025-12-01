import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/events/presentation/screens/home_screen.dart';
import '../../features/events/presentation/screens/client_dashboard_screen.dart';
import '../../features/events/presentation/screens/admin_dashboard_screen.dart';
import '../../features/events/presentation/screens/logistics_dashboard_screen.dart';
import '../../features/events/presentation/screens/kitchen_dashboard_screen.dart';
import '../../features/events/presentation/screens/manager_dashboard_screen.dart';
import '../../features/quotes/presentation/screens/create_quote_screen.dart';
import '../../features/quotes/presentation/screens/my_quotes_screen.dart';
import '../../features/quotes/presentation/screens/admin_quotes_screen.dart';
import '../../features/quotes/presentation/bloc/quote_bloc.dart';
import '../../features/menus/presentation/screens/client_menus_screen.dart';
import '../../features/menus/presentation/bloc/menu_bloc.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../di/injection.dart';

/// Application router configuration with role-based navigation
/// Handles authentication state and redirects based on user role
class AppRouter {
  /// Current authenticated user
  /// Used for role-based navigation decisions
  final UserEntity? currentUser;

  AppRouter({this.currentUser});

  /// Get the dashboard route based on user role
  String _getDashboardRoute(UserRole role) {
    switch (role) {
      case UserRole.cliente:
        return '/dashboard/client';
      case UserRole.admin:
        return '/dashboard/admin';
      case UserRole.logistica:
        return '/dashboard/logistics';
      case UserRole.cocina:
        return '/dashboard/kitchen';
      case UserRole.gestor:
        return '/dashboard/manager';
    }
  }

  /// Create the GoRouter instance
  GoRouter get router => GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuthenticated = currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isHomeRoute = state.matchedLocation == '/home';
      final isDashboardRoute = state.matchedLocation.startsWith('/dashboard');

      // If authenticated and trying to access auth routes, redirect to dashboard
      if (isAuthenticated && isAuthRoute) {
        return _getDashboardRoute(currentUser!.role);
      }

      // If authenticated and on home, redirect to dashboard
      if (isAuthenticated && isHomeRoute) {
        return _getDashboardRoute(currentUser!.role);
      }

      // If not authenticated and trying to access dashboard, redirect to login
      // Preserve the intended destination for post-auth navigation
      if (!isAuthenticated && isDashboardRoute) {
        return '/auth/login?redirect=${Uri.encodeComponent(state.matchedLocation)}';
      }

      // Allow access to home without authentication
      if (isHomeRoute) {
        return null;
      }

      return null;
    },
    routes: [
      // Home route - accessible without authentication
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

      // Auth routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectTo: redirect);
        },
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return RegisterScreen(redirectTo: redirect);
        },
      ),

      // Dashboard routes - role-based
      GoRoute(
        path: '/dashboard/client',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<QuoteBloc>(),
          child: const ClientDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard/admin',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<QuoteBloc>(),
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard/logistics',
        builder: (context, state) => const LogisticsDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/kitchen',
        builder: (context, state) => const KitchenDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/manager',
        builder: (context, state) => const ManagerDashboardScreen(),
      ),

      // Quote routes
      GoRoute(
        path: '/quotes/create',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<QuoteBloc>(),
          child: const CreateQuoteScreen(),
        ),
      ),
      GoRoute(
        path: '/quotes/my-quotes',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<QuoteBloc>(),
          child: const MyQuotesScreen(),
        ),
      ),
      GoRoute(
        path: '/quotes/admin',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<QuoteBloc>(),
          child: const AdminQuotesScreen(),
        ),
      ),

      // Menu routes
      GoRoute(
        path: '/client-menus',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final quoteId = args?['quoteId'] as int?;
          return BlocProvider(
            create: (context) => getIt<MenuBloc>(),
            child: ClientMenusScreen(showAppBar: true, quoteId: quoteId),
          );
        },
      ),

      // Settings route
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Reports route
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
