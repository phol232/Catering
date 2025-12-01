import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/stripe_payment_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripePaymentDatasource stripeDatasource;

  PaymentRepositoryImpl({required this.stripeDatasource});

  @override
  Future<Either<Failure, void>> processStripePayment({
    required double amount,
    required String currency,
    required int quoteId,
    required String customerName,
    required String customerEmail,
  }) async {
    try {
      // 1. Crear Payment Intent
      final paymentIntent = await stripeDatasource.createPaymentIntent(
        amount: amount,
        currency: currency,
        metadata: {
          'quote_id': quoteId,
          'customer_name': customerName,
          'customer_email': customerEmail,
        },
      );

      final clientSecret = paymentIntent['client_secret'] as String;
      final paymentIntentId = paymentIntent['id'] as String;

      // 2. Inicializar Payment Sheet
      await stripeDatasource.initializePaymentSheet(
        paymentIntentClientSecret: clientSecret,
        customerName: customerName,
        customerEmail: customerEmail,
      );

      // 3. Presentar Payment Sheet
      await stripeDatasource.presentPaymentSheet();

      // 4. Guardar el pago en la base de datos
      await stripeDatasource.savePaymentToDatabase(
        eventId: quoteId,
        monto: amount,
        paymentIntentId: paymentIntentId,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
