import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

/// Supabase configuration and initialization
/// Manages Supabase client setup with authentication callbacks and session persistence
class SupabaseConfig {
  /// Initialize Supabase with environment configuration
  /// Sets up auth callback URL for OAuth flows and enables session persistence
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        // Auth callback URL for OAuth (deep linking)
        // Format: [scheme]://[host]/auth-callback
        // Example: com.caterpro.app://auth-callback

        // Session persistence is enabled by default in Supabase Flutter
        // Sessions are stored in secure local storage (SharedPreferences on Android/iOS)
        // and automatically restored on app launch
      ),
      // Enable debug mode in development
      debug: kDebugMode,
    );
  }

  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get the auth client
  static GoTrueClient get auth => client.auth;

  /// Check if Supabase is initialized
  static bool get isInitialized => Supabase.instance.isInitialized;

  /// Get current session
  /// Returns null if no active session exists
  static Session? get currentSession => auth.currentSession;

  /// Get current user
  /// Returns null if no user is authenticated
  static User? get currentUser => auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated =>
      currentSession != null && currentUser != null;

  /// Refresh the current session
  /// Automatically called by Supabase when token is about to expire
  /// Can be called manually if needed
  static Future<AuthResponse> refreshSession() async {
    return await auth.refreshSession();
  }
}
