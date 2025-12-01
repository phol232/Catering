import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int? id;
  final int eventId;
  final String tipo; // SENIAL, SALDO, OTRO
  final double monto;
  final DateTime fecha;
  final String? metodo; // stripe, efectivo, transferencia
  final String estado; // PENDIENTE, PAGADO, ANULADO
  final String? referenciaExterna; // Stripe Payment Intent ID

  const PaymentEntity({
    this.id,
    required this.eventId,
    required this.tipo,
    required this.monto,
    required this.fecha,
    this.metodo,
    required this.estado,
    this.referenciaExterna,
  });

  @override
  List<Object?> get props => [
    id,
    eventId,
    tipo,
    monto,
    fecha,
    metodo,
    estado,
    referenciaExterna,
  ];
}
