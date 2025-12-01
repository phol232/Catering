import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_entity.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';

class MenuFormBottomSheet extends StatefulWidget {
  final MenuEntity? menu;

  const MenuFormBottomSheet({super.key, this.menu});

  @override
  State<MenuFormBottomSheet> createState() => _MenuFormBottomSheetState();
}

class _MenuFormBottomSheetState extends State<MenuFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _tipoController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _costoController;
  bool _estaActivo = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.menu?.nombre ?? '');
    _tipoController = TextEditingController(text: widget.menu?.tipo ?? '');
    _descripcionController = TextEditingController(
      text: widget.menu?.descripcion ?? '',
    );
    _precioController = TextEditingController(
      text: widget.menu?.precioPorPersona.toString() ?? '',
    );
    _costoController = TextEditingController(
      text: widget.menu?.costoPorPersona?.toString() ?? '',
    );
    _estaActivo = widget.menu?.estaActivo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _costoController.dispose();
    super.dispose();
  }

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
                        widget.menu == null ? 'Nuevo Menú' : 'Editar Menú',
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tipoController,
                        decoration: const InputDecoration(
                          labelText: 'Tipo (buffet, cóctel, etc.)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _precioController,
                        decoration: const InputDecoration(
                          labelText: 'Precio por Persona *',
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El precio es requerido';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costoController,
                        decoration: const InputDecoration(
                          labelText: 'Costo por Persona (opcional)',
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                          helperText: 'Para calcular el margen',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              double.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Menú Activo'),
                        value: _estaActivo,
                        onChanged: (value) {
                          setState(() => _estaActivo = value);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            widget.menu == null
                                ? 'Crear Menú'
                                : 'Guardar Cambios',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final menu = MenuEntity(
        id: widget.menu?.id,
        nombre: _nombreController.text.trim(),
        tipo: _tipoController.text.trim().isNotEmpty
            ? _tipoController.text.trim()
            : null,
        descripcion: _descripcionController.text.trim().isNotEmpty
            ? _descripcionController.text.trim()
            : null,
        precioPorPersona: double.parse(_precioController.text),
        costoPorPersona: _costoController.text.isNotEmpty
            ? double.parse(_costoController.text)
            : null,
        estaActivo: _estaActivo,
      );

      if (widget.menu == null) {
        context.read<MenuBloc>().add(CreateMenuEvent(menu));
      } else {
        context.read<MenuBloc>().add(UpdateMenuEvent(menu));
      }

      Navigator.pop(context);
    }
  }
}
