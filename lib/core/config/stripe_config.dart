import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeConfig {
  static String get publishableKey => dotenv.env['API_STRIPE_PUBLIC'] ?? '';

  static String get secretKey => dotenv.env['API_STRIPE_PRIV'] ?? '';

  static String get paymentLink => dotenv.env['API_STRIPE_LINK'] ?? '';
}
