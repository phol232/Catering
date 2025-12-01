import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/event_entity.dart';

/// Card widget to display event information in a list
class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.grayDark,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: event.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.yellowPastel,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.black,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.grayLight,
                            size: 32,
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
                          size: 40,
                        ),
                      ),
                    ),
            ),
          ),

          // Event Details
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  Text(
                    event.nombreEvento,
                    style: const TextStyle(
                      color: AppColors.whiteAlmost,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Event Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.yellowPastel,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy').format(event.fecha),
                        style: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Event Type
                  if (event.tipoEvento != null && event.tipoEvento!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.category,
                          color: AppColors.yellowPastel,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.tipoEvento!,
                            style: const TextStyle(
                              color: AppColors.grayLight,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (event.tipoEvento != null && event.tipoEvento!.isNotEmpty)
                    const SizedBox(height: 3),

                  // Event City
                  if (event.ciudad != null && event.ciudad!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.yellowPastel,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.ciudad!,
                            style: const TextStyle(
                              color: AppColors.grayLight,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (event.ciudad != null && event.ciudad!.isNotEmpty)
                    const SizedBox(height: 3),

                  // Event Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.estado),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusText(event.estado),
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Action Buttons
                  Row(
                    children: [
                      // Edit Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onEdit,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.yellowPastel,
                            side: const BorderSide(
                              color: AppColors.yellowPastel,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, size: 12),
                              SizedBox(width: 2),
                              Text('Editar', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Delete Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(
                              color: AppColors.error,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, size: 12),
                              SizedBox(width: 2),
                              Text('Eliminar', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get color for event status badge
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

  /// Get display text for event status
  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.cotizacion:
        return 'Cotización';
      case EventStatus.reservaPendientePago:
        return 'Pendiente Pago';
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
