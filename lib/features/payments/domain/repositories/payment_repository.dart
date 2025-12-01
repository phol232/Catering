import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> processStripePayment({
    required double amount,
    required String currency,
    required int quoteId,
    required String customerName,
    required String customerEmail,
  });
}
