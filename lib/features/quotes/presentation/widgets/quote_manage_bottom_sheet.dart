import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';

class QuoteManageBottomSheet extends StatefulWidget {
  final QuoteRequestEntity quote;

  const QuoteManageBottomSheet({super.key, required this.quote});

  @override
  State<QuoteManageBottomSheet> createState() => _QuoteManageBottomSheetState();
}

class _QuoteManageBottomSheetState extends State<QuoteManageBottomSheet> {
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    'Gestionar Estado',
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      value: 'RESERVADO',
                      child: Text('Reservado (Señal Pagada)'),
                    ),
                    DropdownMenuItem(
                      value: 'CONFIRMADO',
                      child: Text('Confirmado (Totalmente Pagado)'),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateQuote,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Actualizar Estado'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
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

    // Cerrar ambos bottom sheets
    Navigator.pop(context); // Cierra el manage sheet
    Navigator.pop(context); // Cierra el detail sheet
  }
}
