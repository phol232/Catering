import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/process_stripe_payment.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessStripePayment processStripePayment;

  PaymentBloc({required this.processStripePayment}) : super(PaymentInitial()) {
    on<ProcessStripePaymentEvent>(_onProcessStripePayment);
  }

  Future<void> _onProcessStripePayment(
    ProcessStripePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());

    final result = await processStripePayment(
      amount: event.amount,
      currency: event.currency,
      quoteId: event.quoteId,
      customerName: event.customerName,
      customerEmail: event.customerEmail,
    );

    result.fold(
      (failure) => emit(PaymentFailure(failure.toString())),
      (_) => emit(const PaymentSuccess()),
    );
  }
}
