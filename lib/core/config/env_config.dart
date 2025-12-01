import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration loader for Supabase credentials
/// Validates and provides access to required environment variables
class EnvConfig {
  /// Supabase API URL
  static String get supabaseUrl {
    final url = dotenv.env['API_URL_SUPABASE'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL_SUPABASE is not defined in .env file');
    }
    return url;
  }

  /// Supabase Anonymous Key
  static String get supabaseAnonKey {
    final key = dotenv.env['API_KEY_SUPABASE'];
    if (key == null || key.isEmpty) {
      throw Exception('API_KEY_SUPABASE is not defined in .env file');
    }
    return key;
  }

  /// Load environment variables from .env file
  /// Throws exception if required variables are missing
  static Future<void> load() async {
    await dotenv.load(fileName: 'assets/env/.env');

    // Validate required environment variables
    _validateRequiredVariables();
  }

  /// Validate that all required environment variables are present
  static void _validateRequiredVariables() {
    final requiredVars = ['API_URL_SUPABASE', 'API_KEY_SUPABASE'];
    final missingVars = <String>[];

    for (final varName in requiredVars) {
      final value = dotenv.env[varName];
      if (value == null || value.isEmpty) {
        missingVars.add(varName);
      }
    }

    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missingVars.join(', ')}',
      );
    }
  }
}
