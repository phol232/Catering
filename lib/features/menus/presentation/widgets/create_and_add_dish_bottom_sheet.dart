import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/dish_entity.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';

class CreateAndAddDishBottomSheet extends StatefulWidget {
  final int menuId;

  const CreateAndAddDishBottomSheet({super.key, required this.menuId});

  @override
  State<CreateAndAddDishBottomSheet> createState() =>
      _CreateAndAddDishBottomSheetState();
}

class _CreateAndAddDishBottomSheetState
    extends State<CreateAndAddDishBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _categoriaController;
  bool _esVegetariano = false;
  bool _esVegano = false;
  bool _esSinGluten = false;
  bool _esSinLactosa = false;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _categoriaController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
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
                        'Crear y Agregar Plato',
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
                        controller: _categoriaController,
                        decoration: const InputDecoration(
                          labelText:
                              'Categoría (entrada, fondo, postre, bebida)',
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
                      const Text(
                        'Características',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('Vegetariano'),
                        value: _esVegetariano,
                        onChanged: (value) {
                          setState(() => _esVegetariano = value ?? false);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Vegano'),
                        value: _esVegano,
                        onChanged: (value) {
                          setState(() => _esVegano = value ?? false);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Sin Gluten'),
                        value: _esSinGluten,
                        onChanged: (value) {
                          setState(() => _esSinGluten = value ?? false);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Sin Lactosa'),
                        value: _esSinLactosa,
                        onChanged: (value) {
                          setState(() => _esSinLactosa = value ?? false);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isCreating ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isCreating
                              ? const CircularProgressIndicator()
                              : const Text('Crear y Agregar al Menú'),
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCreating = true);

      final dish = DishEntity(
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim().isNotEmpty
            ? _descripcionController.text.trim()
            : null,
        categoria: _categoriaController.text.trim().isNotEmpty
            ? _categoriaController.text.trim()
            : null,
        esVegetariano: _esVegetariano,
        esVegano: _esVegano,
        esSinGluten: _esSinGluten,
        esSinLactosa: _esSinLactosa,
      );

      // Crear el plato
      final createdDish = await context
          .read<MenuBloc>()
          .menuRepository
          .createDish(dish);

      // Agregar el plato al menú
      await context.read<MenuBloc>().menuRepository.addDishToMenu(
        widget.menuId,
        createdDish.id!,
        1,
      );

      if (mounted) {
        // Recargar los menús
        context.read<MenuBloc>().add(LoadMenusEvent());
        Navigator.pop(context);
      }
    }
  }
}
