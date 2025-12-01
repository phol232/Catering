import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/config/supabase_config.dart';
import 'core/config/stripe_config.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/entities/user_entity.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: 'assets/env/.env');

  // Initialize Stripe (with error handling)
  try {
    Stripe.publishableKey = StripeConfig.publishableKey;
    await Stripe.instance.applySettings();
  } catch (e) {
    debugPrint('Error initializing Stripe: $e');
    // Continue without Stripe if initialization fails
  }

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Setup dependency injection
  await setupDependencies();

  runApp(const CaterProApp());
}

class CaterProApp extends StatelessWidget {
  const CaterProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AuthBloc>()..add(const AuthCheckStatusRequested()),
      child: const _AppRouterBuilder(),
    );
  }
}

class _AppRouterBuilder extends StatelessWidget {
  const _AppRouterBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading screen when auth state is loading
        if (state is AuthLoading) {
          return MaterialApp(
            title: 'CaterPro',
            theme: CateringAppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const LoadingScreen(),
          );
        }

        // Determine current user for router
        UserEntity? currentUser;
        if (state is AuthAuthenticated) {
          currentUser = state.user;
        }

        // Create router with current user
        final router = AppRouter(currentUser: currentUser).router;

        return MaterialApp.router(
          title: 'CaterPro',
          theme: CateringAppTheme.darkTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
