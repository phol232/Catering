import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';
import '../entities/event_entity.dart';

abstract class EventRepository {
  /// Get all events from the database
  Future<Either<Failure, List<EventEntity>>> getAllEvents();

  /// Get a specific event by ID
  Future<Either<Failure, EventEntity>> getEventById(int id);

  /// Create a new event
  Future<Either<Failure, EventEntity>> createEvent(CreateEventParams params);

  /// Update an existing event
  Future<Either<Failure, EventEntity>> updateEvent(UpdateEventParams params);

  /// Delete an event by ID
  Future<Either<Failure, void>> deleteEvent(int id);

  /// Upload an event image to storage and return the URL
  Future<Either<Failure, String>> uploadEventImage(File imageFile);

  /// Delete an event image from storage
  Future<Either<Failure, void>> deleteEventImage(String imageUrl);
}

/// Parameters for creating a new event
class CreateEventParams {
  final int clienteId;
  final int? menuId;
  final String nombreEvento;
  final String? tipoEvento;
  final DateTime fecha;
  final String? horaInicio; // Format: "HH:mm"
  final String? horaFin; // Format: "HH:mm"
  final int numInvitados;
  final String? direccion;
  final String? ciudad;
  final String? notaCliente;
  final String? imageUrl;

  CreateEventParams({
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
    this.notaCliente,
    this.imageUrl,
  });
}

/// Parameters for updating an existing event
class UpdateEventParams {
  final int id;
  final int? clienteId;
  final int? menuId;
  final String? nombreEvento;
  final String? tipoEvento;
  final DateTime? fecha;
  final String? horaInicio; // Format: "HH:mm"
  final String? horaFin; // Format: "HH:mm"
  final int? numInvitados;
  final String? direccion;
  final String? ciudad;
  final String? estado;
  final String? notaCliente;
  final String? imageUrl;

  UpdateEventParams({
    required this.id,
    this.clienteId,
    this.menuId,
    this.nombreEvento,
    this.tipoEvento,
    this.fecha,
    this.horaInicio,
    this.horaFin,
    this.numInvitados,
    this.direccion,
    this.ciudad,
    this.estado,
    this.notaCliente,
    this.imageUrl,
  });
}
