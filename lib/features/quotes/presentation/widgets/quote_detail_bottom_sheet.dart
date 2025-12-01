import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import 'quote_manage_bottom_sheet.dart';

class QuoteDetailBottomSheet extends StatefulWidget {
  final QuoteRequestEntity quote;

  const QuoteDetailBottomSheet({super.key, required this.quote});

  @override
  State<QuoteDetailBottomSheet> createState() => _QuoteDetailBottomSheetState();
}

class _QuoteDetailBottomSheetState extends State<QuoteDetailBottomSheet> {
  void _showManageSheet() async {
    final quoteBloc = context.read<QuoteBloc>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: quoteBloc,
        child: QuoteManageBottomSheet(quote: widget.quote),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
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
                    _buildCompactInfo('Evento', widget.quote.nombreEvento),
                    _buildCompactInfo('Tipo', widget.quote.tipoEvento),
                    _buildCompactInfo(
                      'Fecha',
                      DateFormat('dd/MM/yyyy').format(widget.quote.fechaEvento),
                    ),
                    if (widget.quote.horaInicio != null)
                      _buildCompactInfo(
                        'Horario',
                        '${widget.quote.horaInicio} - ${widget.quote.horaFin ?? ""}',
                      ),
                    _buildCompactInfo(
                      'Invitados',
                      widget.quote.numInvitados.toString(),
                    ),
                    const Divider(height: 20),
                    _buildCompactInfo('Ciudad', widget.quote.ciudad),
                    _buildCompactInfo('Dirección', widget.quote.direccion),
                    if (widget.quote.descripcion != null &&
                        widget.quote.descripcion!.isNotEmpty) ...[
                      const Divider(height: 20),
                      _buildCompactInfo(
                        'Descripción',
                        widget.quote.descripcion!,
                      ),
                    ],
                    if (widget.quote.presupuestoAproximado != null) ...[
                      const Divider(height: 20),
                      _buildCompactInfo(
                        'Presupuesto',
                        'S/ ${widget.quote.presupuestoAproximado!.toStringAsFixed(2)}',
                      ),
                    ],
                    const Divider(height: 20),
                    _buildCompactInfo(
                      'Restricciones',
                      widget.quote.tieneRestricciones
                          ? (widget.quote.detallesRestricciones ?? 'Sí')
                          : 'No',
                    ),
                    const Divider(height: 20),
                    Text(
                      'Servicios Adicionales',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (widget.quote.necesitaMeseros ||
                        widget.quote.necesitaMontaje ||
                        widget.quote.necesitaDecoracion ||
                        widget.quote.necesitaSonido)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (widget.quote.necesitaMeseros)
                            _buildSmallChip('Meseros'),
                          if (widget.quote.necesitaMontaje)
                            _buildSmallChip('Montaje'),
                          if (widget.quote.necesitaDecoracion)
                            _buildSmallChip('Decoración'),
                          if (widget.quote.necesitaSonido)
                            _buildSmallChip('Sonido'),
                        ],
                      )
                    else
                      const Text('Ninguno', style: TextStyle(fontSize: 14)),
                    if (widget.quote.otrosServicios != null &&
                        widget.quote.otrosServicios!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildCompactInfo('Otros', widget.quote.otrosServicios!),
                    ],
                    const Divider(height: 20),
                    _buildCompactInfo(
                      'Teléfono',
                      widget.quote.telefonoContacto,
                    ),
                    _buildCompactInfo('Email', widget.quote.emailContacto),
                    const SizedBox(height: 24),
                    // Botón Gestionar Estado (solo si NO está confirmado)
                    if (widget.quote.estado != 'CONFIRMADO') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showManageSheet,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text('Gestionar Estado'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Mensaje informativo si está confirmado
                    if (widget.quote.estado == 'CONFIRMADO') ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Este pedido está confirmado y totalmente pagado. No se pueden hacer más cambios de estado.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
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

  Widget _buildSmallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.blue),
      ),
    );
  }
}
