import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import 'dish_form_bottom_sheet.dart';

class AddDishToMenuBottomSheet extends StatefulWidget {
  final int menuId;

  const AddDishToMenuBottomSheet({super.key, required this.menuId});

  @override
  State<AddDishToMenuBottomSheet> createState() =>
      _AddDishToMenuBottomSheetState();
}

class _AddDishToMenuBottomSheetState extends State<AddDishToMenuBottomSheet> {
  int? _selectedDishId;
  final _cantidadController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadDishesEvent());
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
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
                    const Expanded(
                      child: Text(
                        'Agregar Plato al Menú',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                  padding: const EdgeInsets.all(24),
                  children: [
                    BlocBuilder<MenuBloc, MenuState>(
                      builder: (context, state) {
                        if (state is MenuLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is DishesLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Seleccionar Plato',
                                  border: OutlineInputBorder(),
                                ),
                                value: _selectedDishId,
                                items: state.dishes.map((dish) {
                                  return DropdownMenuItem(
                                    value: dish.id,
                                    child: Text(dish.nombre),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedDishId = value);
                                },
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () => _showCreateDishSheet(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Crear Nuevo Plato'),
                              ),
                            ],
                          );
                        }

                        return const Text('Error al cargar platos');
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedDishId == null ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Agregar Plato'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    final cantidad = int.tryParse(_cantidadController.text) ?? 1;
    context.read<MenuBloc>().add(
      AddDishToMenuEvent(widget.menuId, _selectedDishId!, cantidad),
    );
    Navigator.pop(context);
  }

  void _showCreateDishSheet(BuildContext context) {
    Navigator.pop(context); // Cerrar el bottom sheet actual
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<MenuBloc>(),
        child: const DishFormBottomSheet(),
      ),
    ).then((_) {
      // Después de crear el plato, recargar la lista de platos
      context.read<MenuBloc>().add(LoadDishesEvent());
    });
  }
}
