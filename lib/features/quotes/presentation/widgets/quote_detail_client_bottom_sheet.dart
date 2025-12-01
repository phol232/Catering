import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';

class QuoteDetailClientBottomSheet extends StatelessWidget {
  final QuoteRequestEntity quote;
  final VoidCallback? onAddMenus;
  final VoidCallback? onPaymentSuccess;
  final VoidCallback? onQuoteUpdated;

  const QuoteDetailClientBottomSheet({
    super.key,
    required this.quote,
    this.onAddMenus,
    this.onPaymentSuccess,
    this.onQuoteUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Detalle del Pedido',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionTitle('Información del Evento'),
                    _buildCompactInfo('Evento', quote.nombreEvento),
                    _buildCompactInfo('Tipo', quote.tipoEvento),
                    _buildCompactInfo(
                      'Fecha',
                      DateFormat('dd/MM/yyyy').format(quote.fechaEvento),
                    ),
                    if (quote.horaInicio != null)
                      _buildCompactInfo('Hora Inicio', quote.horaInicio!),
                    if (quote.horaFin != null)
                      _buildCompactInfo('Hora Fin', quote.horaFin!),
                    _buildCompactInfo(
                      'Número de Invitados',
                      quote.numInvitados.toString(),
                    ),
                    const Divider(height: 24),
                    _buildSectionTitle('Ubicación'),
                    _buildCompactInfo('Ciudad', quote.ciudad),
                    _buildCompactInfo('Dirección', quote.direccion),
                    if (quote.descripcion != null &&
                        quote.descripcion!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildSectionTitle('Descripción'),
                      _buildCompactInfo('Detalles', quote.descripcion!),
                    ],
                    if (quote.presupuestoAproximado != null) ...[
                      const Divider(height: 24),
                      _buildSectionTitle('Presupuesto'),
                      _buildCompactInfo(
                        'Presupuesto Aproximado',
                        'S/ ${quote.presupuestoAproximado!.toStringAsFixed(2)}',
                      ),
                    ],
                    const Divider(height: 24),
                    _buildSectionTitle('Restricciones Alimentarias'),
                    _buildCompactInfo(
                      'Tiene Restricciones',
                      quote.tieneRestricciones ? 'Sí' : 'No',
                    ),
                    if (quote.tieneRestricciones &&
                        quote.detallesRestricciones != null &&
                        quote.detallesRestricciones!.isNotEmpty)
                      _buildCompactInfo(
                        'Detalles',
                        quote.detallesRestricciones!,
                      ),
                    const Divider(height: 24),
                    _buildSectionTitle('Servicios Adicionales'),
                    if (quote.necesitaMeseros ||
                        quote.necesitaMontaje ||
                        quote.necesitaDecoracion ||
                        quote.necesitaSonido)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (quote.necesitaMeseros)
                            _buildServiceChip('Meseros'),
                          if (quote.necesitaMontaje)
                            _buildServiceChip('Montaje'),
                          if (quote.necesitaDecoracion)
                            _buildServiceChip('Decoración'),
                          if (quote.necesitaSonido) _buildServiceChip('Sonido'),
                        ],
                      )
                    else
                      const Text(
                        'No se requieren servicios adicionales',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    if (quote.otrosServicios != null &&
                        quote.otrosServicios!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildCompactInfo(
                        'Otros Servicios',
                        quote.otrosServicios!,
                      ),
                    ],
                    const Divider(height: 24),
                    _buildSectionTitle('Información de Contacto'),
                    _buildCompactInfo('Teléfono', quote.telefonoContacto),
                    _buildCompactInfo('Email', quote.emailContacto),
                    const Divider(height: 24),
                    _buildSectionTitle('Estado del Pedido'),
                    _buildStatusInfo(),
                    if (quote.montoCotizado != null) ...[
                      const SizedBox(height: 16),
                      _buildCompactInfo(
                        'Monto Cotizado',
                        'S/ ${quote.montoCotizado!.toStringAsFixed(2)}',
                      ),
                    ],
                    if (quote.notasAdmin != null &&
                        quote.notasAdmin!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildNotasAdmin(),
                    ],
                    const Divider(height: 24),
                    _buildSectionTitle('Menús Seleccionados'),
                    if (quote.menus != null && quote.menus!.isNotEmpty) ...[
                      ...quote.menus!.map((menu) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.restaurant_menu),
                            title: Text(menu.nombre),
                            subtitle: Text(
                              'S/ ${menu.precioPorPersona.toStringAsFixed(2)} por persona',
                            ),
                            trailing:
                                (quote.estado != 'RESERVADO' &&
                                    quote.estado != 'CONFIRMADO')
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _removeMenu(context, menu.id!),
                                  )
                                : null,
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ] else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No has seleccionado ningún menú aún',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Mostrar cotización automática si hay menús
                    if (quote.menus != null && quote.menus!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withValues(alpha: 0.15),
                              Colors.blue.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calculate,
                                  color: Colors.blue[700],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Cotización Automática',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Desglose de menús
                            Text(
                              'Menús: ${quote.numInvitados} × S/ ${_calcularPrecioPorPersona().toStringAsFixed(2)} = S/ ${(_calcularPrecioPorPersona() * quote.numInvitados).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                            // Desglose de servicios adicionales
                            if (_calcularServiciosAdicionales() > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Servicios: S/ ${_calcularServiciosAdicionales().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                            const Divider(height: 16, color: Colors.blue),
                            Text(
                              'TOTAL: S/ ${(quote.montoCotizado ?? _calcularTotal()).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Botón Confirmar Pedido (solo PENDIENTE con menús)
                    if (quote.estado == 'PENDIENTE' &&
                        quote.menus != null &&
                        quote.menus!.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmarPedido(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.check_circle, size: 24),
                          label: const Text(
                            'Confirmar Pedido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Botón de Pagar (solo si está COTIZADA o ACEPTADA)
                    if (quote.estado == 'COTIZADA' ||
                        quote.estado == 'ACEPTADA') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _procesarPago(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.payment, size: 24),
                          label: const Text(
                            'Proceder al Pago',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Botón de Agregar Menú (solo si está PENDIENTE)
                    if (quote.estado == 'PENDIENTE') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addMenu(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Menú'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Mensaje informativo si está reservado o confirmado
                    if (quote.estado == 'RESERVADO' ||
                        quote.estado == 'CONFIRMADO') ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                quote.estado == 'CONFIRMADO'
                                    ? 'Tu pedido está confirmado y pagado. Ya no se pueden hacer cambios.'
                                    : 'Tu pedido está reservado. Para hacer cambios, contacta al administrador.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildCompactInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
    Color statusColor;
    String statusLabel;

    switch (quote.estado) {
      case 'PENDIENTE':
        statusColor = Colors.orange;
        statusLabel = 'Pendiente';
        break;
      case 'EN_REVISION':
        statusColor = Colors.blue;
        statusLabel = 'En Revisión';
        break;
      case 'COTIZADA':
        statusColor = Colors.purple;
        statusLabel = 'Cotizada';
        break;
      case 'ACEPTADA':
        statusColor = Colors.green;
        statusLabel = 'Aceptada';
        break;
      case 'RESERVADO':
        statusColor = Colors.teal;
        statusLabel = 'Reservado';
        break;
      case 'CONFIRMADO':
        statusColor = Colors.indigo;
        statusLabel = 'Confirmado';
        break;
      case 'RECHAZADA':
        statusColor = Colors.red;
        statusLabel = 'Rechazada';
        break;
      case 'CANCELADA':
        statusColor = Colors.grey;
        statusLabel = 'Cancelada';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = quote.estado;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            statusLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotasAdmin() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Notas del Administrador',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(quote.notasAdmin!, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getServiceIcon(label), size: 16, color: Colors.blue[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Meseros':
        return Icons.person;
      case 'Montaje':
        return Icons.construction;
      case 'Decoración':
        return Icons.celebration;
      case 'Sonido':
        return Icons.volume_up;
      default:
        return Icons.check_circle;
    }
  }

  void _addMenu(BuildContext context) {
    // Cerrar el bottom sheet actual
    Navigator.pop(context);

    // Llamar al callback para cambiar a la pestaña de menús
    if (onAddMenus != null) {
      onAddMenus!();
    }
  }

  void _removeMenu(BuildContext context, int menuId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quitar Menú'),
        content: const Text('¿Deseas quitar este menú de tu pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<QuoteBloc>().add(
                RemoveMenuFromQuoteEvent(quote.id!, menuId),
              );
              Navigator.pop(dialogContext);
              Navigator.pop(context); // Cerrar el bottom sheet
            },
            child: const Text('Quitar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _procesarPago(BuildContext context) {
    // Mostrar directamente el Payment Sheet de Stripe
    _procesarPagoStripe(context);
  }

  void _procesarPagoStripe(BuildContext context) {
    if (quote.montoCotizado == null || quote.montoCotizado! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El monto cotizado no es válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Guardar referencias antes del async
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Mostrar loading mientras se prepara el pago
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Preparando pago...'),
          ],
        ),
      ),
    );

    // Procesar el pago con Stripe
    final paymentBloc = getIt<PaymentBloc>();
    paymentBloc.stream.listen((state) {
      if (state is PaymentSuccess) {
        navigator.pop(); // Cerrar loading
        Navigator.of(context).pop(); // Cerrar el bottom sheet de detalle
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('¡Pago procesado exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        // Llamar al callback para recargar
        if (onPaymentSuccess != null) {
          onPaymentSuccess!();
        }
      } else if (state is PaymentFailure) {
        navigator.pop(); // Cerrar loading
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${state.message}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    paymentBloc.add(
      ProcessStripePaymentEvent(
        amount: quote.montoCotizado!,
        currency: 'pen', // Soles peruanos
        quoteId: quote.id!,
        customerName: quote.clienteNombre ?? 'Cliente',
        customerEmail: quote.emailContacto,
      ),
    );
  }

  // Calcular precio por persona (SUMA de todos los menús)
  double _calcularPrecioPorPersona() {
    if (quote.menus == null || quote.menus!.isEmpty) return 0.0;

    double total = 0.0;
    for (var menu in quote.menus!) {
      total += menu.precioPorPersona;
    }
    return total; // SUMA, no promedio
  }

  // Calcular costo de servicios adicionales
  double _calcularServiciosAdicionales() {
    double total = 0.0;

    // Precios estimados por servicio (ajustables)
    if (quote.necesitaMeseros) {
      total += 200.0; // S/ 200 por meseros
    }
    if (quote.necesitaMontaje) {
      total += 150.0; // S/ 150 por montaje
    }
    if (quote.necesitaDecoracion) {
      total += 300.0; // S/ 300 por decoración
    }
    if (quote.necesitaSonido) {
      total += 250.0; // S/ 250 por sonido
    }

    return total;
  }

  // Calcular total del pedido (menús + servicios)
  double _calcularTotal() {
    if (quote.menus == null || quote.menus!.isEmpty) return 0.0;

    // Total de menús
    double totalMenus = _calcularPrecioPorPersona() * quote.numInvitados;

    // Total de servicios adicionales
    double totalServicios = _calcularServiciosAdicionales();

    return totalMenus + totalServicios;
  }

  // Confirmar pedido (calcular cotización automática)
  void _confirmarPedido(BuildContext context) {
    final total = _calcularTotal();

    final quoteBloc = context.read<QuoteBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.blue[700],
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Confirmar Pedido',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '¿Deseas confirmar tu pedido con los menús seleccionados?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.15),
                    Colors.blue.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total a pagar:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Una vez confirmado, no podrás agregar más menús.',
                      style: TextStyle(fontSize: 13, color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.pop(
                        context,
                      ); // Cerrar el bottom sheet de detalle también
                      quoteBloc.add(
                        UpdateQuoteStatusEvent(
                          quoteId: quote.id!,
                          status: 'COTIZADA',
                          montoCotizado: total,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '✓ Pedido confirmado. Ahora puedes proceder al pago.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Llamar callback para recargar
                      if (onQuoteUpdated != null) {
                        onQuoteUpdated!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Confirmar Pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
