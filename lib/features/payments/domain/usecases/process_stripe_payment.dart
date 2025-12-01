import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../repositories/payment_repository.dart';

class ProcessStripePayment {
  final PaymentRepository repository;

  ProcessStripePayment(this.repository);

  Future<Either<Failure, void>> call({
    required double amount,
    required String currency,
    required int quoteId,
    required String customerName,
    required String customerEmail,
  }) async {
    return await repository.processStripePayment(
      amount: amount,
      currency: currency,
      quoteId: quoteId,
      customerName: customerName,
      customerEmail: customerEmail,
    );
  }
}
