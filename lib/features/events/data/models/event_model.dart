import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';

/// Data model for Event with JSON serialization
class EventModel {
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

  EventModel({
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

  /// Create EventModel from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      clienteId: json['cliente_id'] as int,
      menuId: json['menu_id'] as int?,
      nombreEvento: json['nombre_evento'] as String? ?? '',
      tipoEvento: json['tipo_evento'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
      horaInicio: json['hora_inicio'] != null
          ? _parseTime(json['hora_inicio'] as String)
          : null,
      horaFin: json['hora_fin'] != null
          ? _parseTime(json['hora_fin'] as String)
          : null,
      numInvitados: json['num_invitados'] as int,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: EventStatus.fromString(json['estado'] as String),
      notaCliente: json['nota_cliente'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert EventModel to JSON for database operations
  Map<String, dynamic> toJson() {
    return {
      'cliente_id': clienteId,
      'menu_id': menuId,
      'nombre_evento': nombreEvento,
      'tipo_evento': tipoEvento,
      'fecha': fecha.toIso8601String().split('T')[0],
      'hora_inicio': horaInicio != null
          ? '${horaInicio!.hour.toString().padLeft(2, '0')}:${horaInicio!.minute.toString().padLeft(2, '0')}'
          : null,
      'hora_fin': horaFin != null
          ? '${horaFin!.hour.toString().padLeft(2, '0')}:${horaFin!.minute.toString().padLeft(2, '0')}'
          : null,
      'num_invitados': numInvitados,
      'direccion': direccion,
      'ciudad': ciudad,
      'estado': estado.toUpperCaseString(),
      'nota_cliente': notaCliente,
      'image_url': imageUrl,
    };
  }

  /// Convert EventModel to EventEntity
  EventEntity toEntity() {
    return EventEntity(
      id: id,
      clienteId: clienteId,
      menuId: menuId,
      nombreEvento: nombreEvento,
      tipoEvento: tipoEvento,
      fecha: fecha,
      horaInicio: horaInicio,
      horaFin: horaFin,
      numInvitados: numInvitados,
      direccion: direccion,
      ciudad: ciudad,
      estado: estado,
      notaCliente: notaCliente,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  /// Parse time string (HH:mm) to TimeOfDay
  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
