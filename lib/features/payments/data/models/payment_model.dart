import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.id,
    required super.eventId,
    required super.tipo,
    required super.monto,
    required super.fecha,
    super.metodo,
    required super.estado,
    super.referenciaExterna,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int?,
      eventId: json['event_id'] as int,
      tipo: json['tipo'] as String,
      monto: (json['monto'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha'] as String),
      metodo: json['metodo'] as String?,
      estado: json['estado'] as String,
      referenciaExterna: json['referencia_externa'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'event_id': eventId,
      'tipo': tipo,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
      if (metodo != null) 'metodo': metodo,
      'estado': estado,
      if (referenciaExterna != null) 'referencia_externa': referenciaExterna,
    };
  }
}
