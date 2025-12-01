import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/dish_entity.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import 'menu_form_bottom_sheet.dart';
import 'dish_form_bottom_sheet.dart';
import 'create_and_add_dish_bottom_sheet.dart';

class MenuDetailBottomSheet extends StatefulWidget {
  final MenuEntity menu;

  const MenuDetailBottomSheet({super.key, required this.menu});

  @override
  State<MenuDetailBottomSheet> createState() => _MenuDetailBottomSheetState();
}

class _MenuDetailBottomSheetState extends State<MenuDetailBottomSheet> {
  late MenuEntity currentMenu;

  @override
  void initState() {
    super.initState();
    currentMenu = widget.menu;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomSheet(context);
  }

  Future<void> _reloadMenu() async {
    final menuBloc = context.read<MenuBloc>();
    menuBloc.add(LoadMenusEvent());

    // Esperar a que el BLoC emita el nuevo estado
    await menuBloc.stream.firstWhere((state) => state is MenusLoaded);

    if (mounted) {
      final state = menuBloc.state;
      if (state is MenusLoaded) {
        try {
          final updatedMenu = state.menus.firstWhere(
            (m) => m.id == currentMenu.id,
          );
          setState(() {
            currentMenu = updatedMenu;
          });
        } catch (e) {
          // Si no se encuentra, mantener el actual
        }
      }
    }
  }

  Widget _buildBottomSheet(BuildContext context) {
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
                        currentMenu.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditForm(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _confirmDelete(context),
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
                    if (currentMenu.tipo != null) ...[
                      _buildInfoRow('Tipo', currentMenu.tipo!),
                      const SizedBox(height: 8),
                    ],
                    if (currentMenu.descripcion != null) ...[
                      _buildInfoRow('Descripción', currentMenu.descripcion!),
                      const SizedBox(height: 8),
                    ],
                    _buildInfoRow(
                      'Precio por Persona',
                      'S/ ${currentMenu.precioPorPersona.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    if (currentMenu.costoPorPersona != null) ...[
                      _buildInfoRow(
                        'Costo por Persona',
                        'S/ ${currentMenu.costoPorPersona!.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Margen',
                        '${currentMenu.margen!.toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 8),
                    ],
                    _buildInfoRow(
                      'Estado',
                      currentMenu.estaActivo ? 'Activo' : 'Inactivo',
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Platos del Menú',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showAddDishSheet(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (currentMenu.dishes == null ||
                        currentMenu.dishes!.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'No hay platos en este menú',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    else
                      ...currentMenu.dishes!.map((dish) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.restaurant),
                            title: Text(dish.nombre),
                            subtitle: dish.categoria != null
                                ? Text(dish.categoria!)
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () => _editDish(context, dish),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _removeDish(context, dish.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showEditForm(BuildContext context) async {
    final menuBloc = context.read<MenuBloc>();

    // Abrir el bottom sheet de editar menú (encima del actual)
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: menuBloc,
        child: MenuFormBottomSheet(menu: currentMenu),
      ),
    );

    // Después de editar el menú, recargar
    if (mounted) {
      await _reloadMenu();
    }
  }

  void _showAddDishSheet(BuildContext context) async {
    final menuBloc = context.read<MenuBloc>();

    // Abrir el bottom sheet de crear y agregar plato (encima del actual)
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: menuBloc,
        child: CreateAndAddDishBottomSheet(menuId: currentMenu.id!),
      ),
    );

    // Después de agregar el plato, recargar
    if (mounted) {
      await _reloadMenu();
    }
  }

  void _removeDish(BuildContext context, int dishId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quitar Plato'),
        content: const Text('¿Quitar este plato del menú?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<MenuBloc>().add(
                RemoveDishFromMenuEvent(currentMenu.id!, dishId),
              );
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Quitar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editDish(BuildContext context, DishEntity dish) async {
    final menuBloc = context.read<MenuBloc>();

    // Primero recargar para obtener los datos más recientes
    menuBloc.add(LoadMenusEvent());
    await menuBloc.stream.firstWhere((state) => state is MenusLoaded);

    // Obtener el plato actualizado
    DishEntity dishToEdit = dish;
    final state = menuBloc.state;
    if (state is MenusLoaded && mounted) {
      try {
        final updatedMenu = state.menus.firstWhere(
          (m) => m.id == currentMenu.id,
        );
        final updatedDish = updatedMenu.dishes?.firstWhere(
          (d) => d.id == dish.id,
        );
        if (updatedDish != null) {
          dishToEdit = updatedDish;
          setState(() {
            currentMenu = updatedMenu;
          });
        }
      } catch (e) {
        // Si no se encuentra, usar el original
      }
    }

    // Abrir el bottom sheet de editar plato con los datos actualizados
    if (mounted) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => BlocProvider.value(
          value: menuBloc,
          child: DishFormBottomSheet(dish: dishToEdit),
        ),
      );

      // Después de editar el plato, recargar el menú
      if (mounted) {
        await _reloadMenu();
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Menú'),
        content: Text('¿Estás seguro de eliminar "${currentMenu.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<MenuBloc>().add(DeleteMenuEvent(currentMenu.id!));
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
