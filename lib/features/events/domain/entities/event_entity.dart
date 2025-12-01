import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EventEntity extends Equatable {
  final int id;
  final int clienteId;
  final int? menuId;
  final String nombreEvento;
  final String? tipoEvento;
  final DateTime fecha;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFin;
  final int numInvitados;
  final String? direccion;
  final String? ciudad;
  final EventStatus estado;
  final String? notaCliente;
  final String? imageUrl;
  final DateTime createdAt;

  const EventEntity({
    required this.id,
    required this.clienteId,
    this.menuId,
    required this.nombreEvento,
    this.tipoEvento,
    required this.fecha,
    this.horaInicio,
    this.horaFin,
    required this.numInvitados,
    this.direccion,
    this.ciudad,
    required this.estado,
    this.notaCliente,
    this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    clienteId,
    menuId,
    nombreEvento,
    tipoEvento,
    fecha,
    horaInicio,
    horaFin,
    numInvitados,
    direccion,
    ciudad,
    estado,
    notaCliente,
    imageUrl,
    createdAt,
  ];
}

enum EventStatus {
  cotizacion,
  reservaPendientePago,
  reservado,
  confirmado,
  enProceso,
  finalizado,
  cancelado;

  static EventStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'COTIZACION':
        return EventStatus.cotizacion;
      case 'RESERVA_PENDIENTE_PAGO':
        return EventStatus.reservaPendientePago;
      case 'RESERVADO':
        return EventStatus.reservado;
      case 'CONFIRMADO':
        return EventStatus.confirmado;
      case 'EN_PROCESO':
        return EventStatus.enProceso;
      case 'FINALIZADO':
        return EventStatus.finalizado;
      case 'CANCELADO':
        return EventStatus.cancelado;
      default:
        throw ArgumentError('Invalid event status: $value');
    }
  }

  String toUpperCaseString() {
    switch (this) {
      case EventStatus.cotizacion:
        return 'COTIZACION';
      case EventStatus.reservaPendientePago:
        return 'RESERVA_PENDIENTE_PAGO';
      case EventStatus.reservado:
        return 'RESERVADO';
      case EventStatus.confirmado:
        return 'CONFIRMADO';
      case EventStatus.enProceso:
        return 'EN_PROCESO';
      case EventStatus.finalizado:
        return 'FINALIZADO';
      case EventStatus.cancelado:
        return 'CANCELADO';
    }
  }
}
