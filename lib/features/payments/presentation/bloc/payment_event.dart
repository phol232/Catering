import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessStripePaymentEvent extends PaymentEvent {
  final double amount;
  final String currency;
  final int quoteId;
  final String customerName;
  final String customerEmail;

  const ProcessStripePaymentEvent({
    required this.amount,
    required this.currency,
    required this.quoteId,
    required this.customerName,
    required this.customerEmail,
  });

  @override
  List<Object?> get props => [
    amount,
    currency,
    quoteId,
    customerName,
    customerEmail,
  ];
}
