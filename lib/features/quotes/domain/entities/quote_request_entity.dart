import 'package:equatable/equatable.dart';
import '../../../menus/domain/entities/menu_entity.dart';

/// Quote request entity
class QuoteRequestEntity extends Equatable {
  final int? id;
  final int clienteId;
  final String? clienteNombre;
  final String nombreEvento;
  final String tipoEvento;
  final DateTime fechaEvento;
  final String? horaInicio;
  final String? horaFin;
  final int numInvitados;
  final String direccion;
  final String ciudad;
  final String? tipoServicio;
  final String? descripcion;
  final double? presupuestoAproximado;
  final bool tieneRestricciones;
  final String? detallesRestricciones;
  final bool necesitaMeseros;
  final bool necesitaMontaje;
  final bool necesitaDecoracion;
  final bool necesitaSonido;
  final String? otrosServicios;
  final String telefonoContacto;
  final String emailContacto;
  final String estado;
  final double? montoCotizado;
  final String? notasAdmin;
  final List<MenuEntity>? menus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuoteRequestEntity({
    this.id,
    required this.clienteId,
    this.clienteNombre,
    required this.nombreEvento,
    required this.tipoEvento,
    required this.fechaEvento,
    this.horaInicio,
    this.horaFin,
    required this.numInvitados,
    required this.direccion,
    required this.ciudad,
    this.tipoServicio,
    this.descripcion,
    this.presupuestoAproximado,
    this.tieneRestricciones = false,
    this.detallesRestricciones,
    this.necesitaMeseros = false,
    this.necesitaMontaje = false,
    this.necesitaDecoracion = false,
    this.necesitaSonido = false,
    this.otrosServicios,
    required this.telefonoContacto,
    required this.emailContacto,
    this.estado = 'PENDIENTE',
    this.montoCotizado,
    this.notasAdmin,
    this.menus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    clienteId,
    clienteNombre,
    nombreEvento,
    tipoEvento,
    fechaEvento,
    horaInicio,
    horaFin,
    numInvitados,
    direccion,
    ciudad,
    tipoServicio,
    descripcion,
    presupuestoAproximado,
    tieneRestricciones,
    detallesRestricciones,
    necesitaMeseros,
    necesitaMontaje,
    necesitaDecoracion,
    necesitaSonido,
    otrosServicios,
    telefonoContacto,
    emailContacto,
    estado,
    montoCotizado,
    notasAdmin,
    menus,
    createdAt,
    updatedAt,
  ];

  QuoteRequestEntity copyWith({
    int? id,
    int? clienteId,
    String? clienteNombre,
    String? nombreEvento,
    String? tipoEvento,
    DateTime? fechaEvento,
    String? horaInicio,
    String? horaFin,
    int? numInvitados,
    String? direccion,
    String? ciudad,
    String? tipoServicio,
    String? descripcion,
    double? presupuestoAproximado,
    bool? tieneRestricciones,
    String? detallesRestricciones,
    bool? necesitaMeseros,
    bool? necesitaMontaje,
    bool? necesitaDecoracion,
    bool? necesitaSonido,
    String? otrosServicios,
    String? telefonoContacto,
    String? emailContacto,
    String? estado,
    double? montoCotizado,
    String? notasAdmin,
    List<MenuEntity>? menus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuoteRequestEntity(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      nombreEvento: nombreEvento ?? this.nombreEvento,
      tipoEvento: tipoEvento ?? this.tipoEvento,
      fechaEvento: fechaEvento ?? this.fechaEvento,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      numInvitados: numInvitados ?? this.numInvitados,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      descripcion: descripcion ?? this.descripcion,
      presupuestoAproximado:
          presupuestoAproximado ?? this.presupuestoAproximado,
      tieneRestricciones: tieneRestricciones ?? this.tieneRestricciones,
      detallesRestricciones:
          detallesRestricciones ?? this.detallesRestricciones,
      necesitaMeseros: necesitaMeseros ?? this.necesitaMeseros,
      necesitaMontaje: necesitaMontaje ?? this.necesitaMontaje,
      necesitaDecoracion: necesitaDecoracion ?? this.necesitaDecoracion,
      necesitaSonido: necesitaSonido ?? this.necesitaSonido,
      otrosServicios: otrosServicios ?? this.otrosServicios,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      emailContacto: emailContacto ?? this.emailContacto,
      estado: estado ?? this.estado,
      montoCotizado: montoCotizado ?? this.montoCotizado,
      notasAdmin: notasAdmin ?? this.notasAdmin,
      menus: menus ?? this.menus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
