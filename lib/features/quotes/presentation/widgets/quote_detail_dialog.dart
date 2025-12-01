import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';

class QuoteDetailDialog extends StatefulWidget {
  final QuoteRequestEntity quote;

  const QuoteDetailDialog({super.key, required this.quote});

  @override
  State<QuoteDetailDialog> createState() => _QuoteDetailDialogState();
}

class _QuoteDetailDialogState extends State<QuoteDetailDialog> {
  final _montoCotizadoController = TextEditingController();
  final _notasAdminController = TextEditingController();
  String _selectedStatus = 'PENDIENTE';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.quote.estado;
    if (widget.quote.montoCotizado != null) {
      _montoCotizadoController.text = widget.quote.montoCotizado.toString();
    }
    if (widget.quote.notasAdmin != null) {
      _notasAdminController.text = widget.quote.notasAdmin!;
    }
  }

  @override
  void dispose() {
    _montoCotizadoController.dispose();
    _notasAdminController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detalle de Cotización',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
                padding: const EdgeInsets.all(16),
                children: [
                  _buildInfoSection('Información del Evento', [
                    _buildInfoRow('Nombre', widget.quote.nombreEvento),
                    _buildInfoRow('Tipo', widget.quote.tipoEvento),
                    _buildInfoRow(
                      'Fecha',
                      DateFormat('dd/MM/yyyy').format(widget.quote.fechaEvento),
                    ),
                    if (widget.quote.horaInicio != null)
                      _buildInfoRow('Hora Inicio', widget.quote.horaInicio!),
                    if (widget.quote.horaFin != null)
                      _buildInfoRow('Hora Fin', widget.quote.horaFin!),
                    _buildInfoRow(
                      'Invitados',
                      widget.quote.numInvitados.toString(),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Ubicación', [
                    _buildInfoRow('Ciudad', widget.quote.ciudad),
                    _buildInfoRow('Dirección', widget.quote.direccion),
                  ]),
                  const SizedBox(height: 16),
                  if (widget.quote.descripcion != null)
                    _buildInfoSection('Descripción', [
                      Text(widget.quote.descripcion!),
                    ]),
                  const SizedBox(height: 16),
                  if (widget.quote.presupuestoAproximado != null)
                    _buildInfoSection('Presupuesto', [
                      _buildInfoRow(
                        'Aproximado',
                        'S/ ${widget.quote.presupuestoAproximado!.toStringAsFixed(2)}',
                      ),
                    ]),
                  const SizedBox(height: 16),
                  if (widget.quote.tieneRestricciones)
                    _buildInfoSection('Restricciones Alimentarias', [
                      Text(widget.quote.detallesRestricciones ?? 'Sí'),
                    ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Servicios Adicionales', [
                    if (widget.quote.necesitaMeseros)
                      const Chip(label: Text('Meseros')),
                    if (widget.quote.necesitaMontaje)
                      const Chip(label: Text('Montaje')),
                    if (widget.quote.necesitaDecoracion)
                      const Chip(label: Text('Decoración')),
                    if (widget.quote.necesitaSonido)
                      const Chip(label: Text('Sonido')),
                    if (widget.quote.otrosServicios != null)
                      Text('Otros: ${widget.quote.otrosServicios}'),
                  ]),
                  const SizedBox(height: 16),
                  _buildInfoSection('Contacto', [
                    _buildInfoRow('Teléfono', widget.quote.telefonoContacto),
                    _buildInfoRow('Email', widget.quote.emailContacto),
                  ]),
                  const Divider(height: 32),
                  const Text(
                    'Gestión de Cotización',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'PENDIENTE',
                        child: Text('Pendiente'),
                      ),
                      DropdownMenuItem(
                        value: 'EN_REVISION',
                        child: Text('En Revisión'),
                      ),
                      DropdownMenuItem(
                        value: 'COTIZADA',
                        child: Text('Cotizada'),
                      ),
                      DropdownMenuItem(
                        value: 'ACEPTADA',
                        child: Text('Aceptada'),
                      ),
                      DropdownMenuItem(
                        value: 'RECHAZADA',
                        child: Text('Rechazada'),
                      ),
                      DropdownMenuItem(
                        value: 'CANCELADA',
                        child: Text('Cancelada'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedStatus = value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _montoCotizadoController,
                    decoration: const InputDecoration(
                      labelText: 'Monto Cotizado',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notasAdminController,
                    decoration: const InputDecoration(
                      labelText: 'Notas del Administrador',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateQuote,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Actualizar Cotización'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _updateQuote() {
    final montoCotizado = _montoCotizadoController.text.isEmpty
        ? null
        : double.tryParse(_montoCotizadoController.text);

    final notasAdmin = _notasAdminController.text.isEmpty
        ? null
        : _notasAdminController.text;

    context.read<QuoteBloc>().add(
      UpdateQuoteStatusEvent(
        quoteId: widget.quote.id!,
        status: _selectedStatus,
        montoCotizado: montoCotizado,
        notasAdmin: notasAdmin,
      ),
    );

    Navigator.pop(context);
  }
}
