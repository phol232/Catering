import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/event_entity.dart';

/// Event detail screen - shows complete information about an event
class EventDetailScreen extends StatelessWidget {
  final EventEntity event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.grayDark,
            iconTheme: const IconThemeData(color: AppColors.whiteAlmost),
            flexibleSpace: FlexibleSpaceBar(
              background: event.imageUrl != null && event.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.yellowPastel,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.black,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.grayLight,
                            size: 64,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.black,
                      child: const Center(
                        child: Icon(
                          Icons.event,
                          color: AppColors.grayLight,
                          size: 80,
                        ),
                      ),
                    ),
            ),
          ),

          // Event Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    event.nombreEvento,
                    style: const TextStyle(
                      color: AppColors.whiteAlmost,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.estado),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(event.estado),
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Event Type
                  if (event.tipoEvento != null && event.tipoEvento!.isNotEmpty)
                    _buildInfoRow(
                      Icons.category,
                      'Tipo de Evento',
                      event.tipoEvento!,
                    ),

                  // Date
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Fecha',
                    DateFormat('dd/MM/yyyy').format(event.fecha),
                  ),

                  // Time
                  if (event.horaInicio != null || event.horaFin != null)
                    _buildInfoRow(
                      Icons.access_time,
                      'Horario',
                      _formatTimeRange(event.horaInicio, event.horaFin),
                    ),

                  // Number of Guests
                  _buildInfoRow(
                    Icons.people,
                    'Número de Invitados',
                    '${event.numInvitados} personas',
                  ),

                  // Location
                  if (event.direccion != null && event.direccion!.isNotEmpty)
                    _buildInfoRow(
                      Icons.location_on,
                      'Dirección',
                      event.direccion!,
                    ),

                  // City
                  if (event.ciudad != null && event.ciudad!.isNotEmpty)
                    _buildInfoRow(Icons.location_city, 'Ciudad', event.ciudad!),

                  // Client Notes
                  if (event.notaCliente != null &&
                      event.notaCliente!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Notas del Cliente',
                      style: TextStyle(
                        color: AppColors.whiteAlmost,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.grayDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.notaCliente!,
                        style: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.yellowPastel, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.grayLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.whiteAlmost,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(TimeOfDay? start, TimeOfDay? end) {
    if (start == null && end == null) return 'No especificado';
    if (start != null && end == null) {
      return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    }
    if (start == null && end != null) {
      return 'Hasta ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    }
    return '${start!.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end!.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.cotizacion:
        return AppColors.info;
      case EventStatus.reservaPendientePago:
        return AppColors.warning;
      case EventStatus.reservado:
        return AppColors.yellowPastel;
      case EventStatus.confirmado:
        return AppColors.success;
      case EventStatus.enProceso:
        return AppColors.info;
      case EventStatus.finalizado:
        return AppColors.grayLight;
      case EventStatus.cancelado:
        return AppColors.error;
    }
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.cotizacion:
        return 'Cotización';
      case EventStatus.reservaPendientePago:
        return 'Pendiente de Pago';
      case EventStatus.reservado:
        return 'Reservado';
      case EventStatus.confirmado:
        return 'Confirmado';
      case EventStatus.enProceso:
        return 'En Proceso';
      case EventStatus.finalizado:
        return 'Finalizado';
      case EventStatus.cancelado:
        return 'Cancelado';
    }
  }
}
