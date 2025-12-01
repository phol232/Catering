import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_model.dart';

/// Remote data source for event operations using Supabase
abstract class EventRemoteDataSource {
  /// Get all events from the database
  Future<List<EventModel>> getAllEvents();

  /// Get a specific event by ID
  Future<EventModel> getEventById(int id);

  /// Create a new event
  Future<EventModel> createEvent(CreateEventParams params);

  /// Update an existing event
  Future<EventModel> updateEvent(UpdateEventParams params);

  /// Delete an event by ID
  Future<void> deleteEvent(int id);
}

/// Implementation of EventRemoteDataSource using Supabase
class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final SupabaseClient supabaseClient;

  EventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      final response = await supabaseClient
          .from('events')
          .select()
          .order('fecha', ascending: false);

      return (response as List)
          .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: $e');
    }
  }

  @override
  Future<EventModel> getEventById(int id) async {
    try {
      final response = await supabaseClient
          .from('events')
          .select()
          .eq('id', id)
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener evento: $e');
    }
  }

  @override
  Future<EventModel> createEvent(CreateEventParams params) async {
    try {
      final data = {
        'cliente_id': params.clienteId,
        'menu_id': params.menuId,
        'nombre_evento': params.nombreEvento,
        'tipo_evento': params.tipoEvento,
        'fecha': params.fecha.toIso8601String().split('T')[0],
        'hora_inicio': params.horaInicio,
        'hora_fin': params.horaFin,
        'num_invitados': params.numInvitados,
        'direccion': params.direccion,
        'ciudad': params.ciudad,
        'nota_cliente': params.notaCliente,
        'image_url': params.imageUrl,
      };

      final response = await supabaseClient
          .from('events')
          .insert(data)
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  @override
  Future<EventModel> updateEvent(UpdateEventParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.clienteId != null) {
        data['cliente_id'] = params.clienteId;
      }
      if (params.menuId != null) {
        data['menu_id'] = params.menuId;
      }
      if (params.nombreEvento != null) {
        data['nombre_evento'] = params.nombreEvento;
      }
      if (params.tipoEvento != null) {
        data['tipo_evento'] = params.tipoEvento;
      }
      if (params.fecha != null) {
        data['fecha'] = params.fecha!.toIso8601String().split('T')[0];
      }
      if (params.horaInicio != null) {
        data['hora_inicio'] = params.horaInicio;
      }
      if (params.horaFin != null) {
        data['hora_fin'] = params.horaFin;
      }
      if (params.numInvitados != null) {
        data['num_invitados'] = params.numInvitados;
      }
      if (params.direccion != null) {
        data['direccion'] = params.direccion;
      }
      if (params.ciudad != null) {
        data['ciudad'] = params.ciudad;
      }
      if (params.estado != null) {
        data['estado'] = params.estado;
      }
      if (params.notaCliente != null) {
        data['nota_cliente'] = params.notaCliente;
      }
      if (params.imageUrl != null) {
        data['image_url'] = params.imageUrl;
      }

      final response = await supabaseClient
          .from('events')
          .update(data)
          .eq('id', params.id)
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar evento: $e');
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      await supabaseClient.from('events').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar evento: $e');
    }
  }
}
