import '../../domain/entities/quote_request_entity.dart';
import '../../../menus/data/models/menu_model.dart';

class QuoteRequestModel extends QuoteRequestEntity {
  const QuoteRequestModel({
    super.id,
    required super.clienteId,
    super.clienteNombre,
    required super.nombreEvento,
    required super.tipoEvento,
    required super.fechaEvento,
    super.horaInicio,
    super.horaFin,
    required super.numInvitados,
    required super.direccion,
    required super.ciudad,
    super.tipoServicio,
    super.descripcion,
    super.presupuestoAproximado,
    super.tieneRestricciones,
    super.detallesRestricciones,
    super.necesitaMeseros,
    super.necesitaMontaje,
    super.necesitaDecoracion,
    super.necesitaSonido,
    super.otrosServicios,
    required super.telefonoContacto,
    required super.emailContacto,
    super.estado,
    super.montoCotizado,
    super.notasAdmin,
    super.menus,
    super.createdAt,
    super.updatedAt,
  });

  factory QuoteRequestModel.fromJson(Map<String, dynamic> json) {
    return QuoteRequestModel(
      id: json['id'] as int?,
      clienteId: json['cliente_id'] as int,
      clienteNombre: json['cliente_nombre'] as String?,
      nombreEvento: json['nombre_evento'] as String,
      tipoEvento: json['tipo_evento'] as String,
      fechaEvento: DateTime.parse(json['fecha_evento'] as String),
      horaInicio: json['hora_inicio'] as String?,
      horaFin: json['hora_fin'] as String?,
      numInvitados: json['num_invitados'] as int,
      direccion: json['direccion'] as String,
      ciudad: json['ciudad'] as String,
      tipoServicio: json['tipo_servicio'] as String?,
      descripcion: json['descripcion'] as String?,
      presupuestoAproximado: json['presupuesto_aproximado'] != null
          ? (json['presupuesto_aproximado'] as num).toDouble()
          : null,
      tieneRestricciones: json['tiene_restricciones'] as bool? ?? false,
      detallesRestricciones: json['detalles_restricciones'] as String?,
      necesitaMeseros: json['necesita_meseros'] as bool? ?? false,
      necesitaMontaje: json['necesita_montaje'] as bool? ?? false,
      necesitaDecoracion: json['necesita_decoracion'] as bool? ?? false,
      necesitaSonido: json['necesita_sonido'] as bool? ?? false,
      otrosServicios: json['otros_servicios'] as String?,
      telefonoContacto: json['telefono_contacto'] as String,
      emailContacto: json['email_contacto'] as String,
      estado: json['estado'] as String? ?? 'PENDIENTE',
      montoCotizado: json['monto_cotizado'] != null
          ? (json['monto_cotizado'] as num).toDouble()
          : null,
      notasAdmin: json['notas_admin'] as String?,
      menus: json['menus'] != null
          ? (json['menus'] as List)
                .map((m) => MenuModel.fromJson(m as Map<String, dynamic>))
                .toList()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cliente_id': clienteId,
      'nombre_evento': nombreEvento,
      'tipo_evento': tipoEvento,
      'fecha_evento': fechaEvento.toIso8601String().split('T')[0],
      if (horaInicio != null) 'hora_inicio': horaInicio,
      if (horaFin != null) 'hora_fin': horaFin,
      'num_invitados': numInvitados,
      'direccion': direccion,
      'ciudad': ciudad,
      if (tipoServicio != null) 'tipo_servicio': tipoServicio,
      if (descripcion != null) 'descripcion': descripcion,
      if (presupuestoAproximado != null)
        'presupuesto_aproximado': presupuestoAproximado,
      'telefono_contacto': telefonoContacto,
      'email_contacto': emailContacto,
      'estado': estado,
      if (montoCotizado != null) 'monto_cotizado': montoCotizado,
      if (notasAdmin != null) 'notas_admin': notasAdmin,
    };
  }
}
