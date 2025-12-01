import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signInWithPassword(String email, String password);

  /// Sign up with email and password
  Future<UserModel> signUp(String email, String password, String nombre);

  /// Sign in with Google OAuth
  Future<UserModel> signInWithOAuth();

  /// Sign out current user
  Future<void> signOut();

  /// Get current session
  Future<UserModel?> currentSession();

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      print('🔵 Starting login for: $email');

      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('🔵 Auth response: ${response.user?.id}');

      if (response.user == null) {
        throw Exception('Authentication failed');
      }

      print('🔵 Fetching user profile from database...');

      // Fetch user profile from users table
      final userProfile = await supabaseClient
          .from('users')
          .select()
          .eq('email', email)
          .single();

      print('🔵 User profile found: ${userProfile['id']}');

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      print('❌ Auth error: ${e.message}');
      throw Exception('Auth error: ${e.message}');
    } on PostgrestException catch (e) {
      print('❌ Database error: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String nombre) async {
    try {
      print('🔵 Starting sign up for: $email');

      // Sign up with Supabase Auth
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      print('🔵 Auth response: ${response.user?.id}');

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      print('🔵 Creating user profile in database...');

      // Create user profile in users table
      final userProfile = await supabaseClient
          .from('users')
          .insert({
            'nombre': nombre,
            'email': email,
            'password_hash': '', // Supabase Auth handles password
            'role': 'CLIENTE',
          })
          .select()
          .single();

      print('🔵 User profile created: ${userProfile['id']}');

      return UserModel.fromJson(userProfile);
    } on AuthException catch (e) {
      print('❌ Auth error: ${e.message}');
      throw Exception('Auth error: ${e.message}');
    } on PostgrestException catch (e) {
      print('❌ Database error: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<UserModel> signInWithOAuth() async {
    try {
      final response = await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.cateringapp://login-callback',
      );

      if (!response) {
        throw Exception('OAuth sign in failed');
      }

      // Wait for auth state change
      await Future.delayed(const Duration(seconds: 2));

      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('No user after OAuth');
      }

      // Check if user profile exists, create if not
      final existingProfile = await supabaseClient
          .from('users')
          .select()
          .eq('email', user.email!)
          .maybeSingle();

      if (existingProfile == null) {
        // Create user profile
        final userProfile = await supabaseClient
            .from('users')
            .insert({
              'nombre':
                  user.userMetadata?['full_name'] ?? user.email!.split('@')[0],
              'email': user.email!,
              'password_hash': '', // OAuth user
              'role': 'CLIENTE',
            })
            .select()
            .single();

        return UserModel.fromJson(userProfile);
      }

      return UserModel.fromJson(existingProfile);
    } on AuthException catch (e) {
      throw Exception('OAuth error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel?> currentSession() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        return null;
      }

      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }

      // Fetch user profile from users table
      final userProfile = await supabaseClient
          .from('users')
          .select()
          .eq('email', user.email!)
          .maybeSingle();

      if (userProfile == null) {
        return null;
      }

      return UserModel.fromJson(userProfile);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<AuthState> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange;
  }
}
