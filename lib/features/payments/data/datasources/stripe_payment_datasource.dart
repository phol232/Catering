import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/stripe_config.dart';
import '../models/payment_model.dart';

abstract class StripePaymentDatasource {
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required Map<String, dynamic> metadata,
  });

  Future<void> initializePaymentSheet({
    required String paymentIntentClientSecret,
    required String customerName,
    required String customerEmail,
  });

  Future<void> presentPaymentSheet();

  Future<PaymentModel> savePaymentToDatabase({
    required int eventId,
    required double monto,
    required String paymentIntentId,
  });
}

class StripePaymentDatasourceImpl implements StripePaymentDatasource {
  final http.Client client;
  final SupabaseClient supabaseClient;

  StripePaymentDatasourceImpl({
    required this.client,
    required this.supabaseClient,
  });

  @override
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      // Convertir el monto a centavos (Stripe usa centavos)
      final amountInCents = (amount * 100).toInt();

      final response = await client.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
          ...metadata.map(
            (key, value) => MapEntry('metadata[$key]', value.toString()),
          ),
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al crear Payment Intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en createPaymentIntent: $e');
    }
  }

  @override
  Future<void> initializePaymentSheet({
    required String paymentIntentClientSecret,
    required String customerName,
    required String customerEmail,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'CaterPro',
          customerEphemeralKeySecret: null,
          customerId: null,
          style: ThemeMode.system,
          billingDetails: BillingDetails(
            name: customerName,
            email: customerEmail,
          ),
        ),
      );
    } catch (e) {
      throw Exception('Error al inicializar Payment Sheet: $e');
    }
  }

  @override
  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (e is StripeException) {
        throw Exception('Pago cancelado: ${e.error.localizedMessage}');
      }
      throw Exception('Error al presentar Payment Sheet: $e');
    }
  }

  @override
  Future<PaymentModel> savePaymentToDatabase({
    required int eventId,
    required double monto,
    required String paymentIntentId,
  }) async {
    try {
      final paymentData = {
        'event_id': eventId,
        'tipo':
            'SENIAL', // Por defecto es señal, puedes cambiarlo según tu lógica
        'monto': monto,
        'fecha': DateTime.now().toIso8601String(),
        'metodo': 'stripe',
        'estado': 'PAGADO',
        'referencia_externa': paymentIntentId,
      };

      final response = await supabaseClient
          .from('payments')
          .insert(paymentData)
          .select()
          .single();

      return PaymentModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al guardar pago en base de datos: $e');
    }
  }
}
