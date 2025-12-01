import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/menu_entity.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_state.dart';
import 'menu_form_bottom_sheet.dart';
import 'menu_detail_bottom_sheet.dart';

class MenuListTab extends StatefulWidget {
  const MenuListTab({super.key});

  @override
  State<MenuListTab> createState() => _MenuListTabState();
}

class _MenuListTabState extends State<MenuListTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenusLoaded) {
            if (state.menus.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay menús registrados',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.menus.length,
              itemBuilder: (context, index) {
                final menu = state.menus[index];
                return _MenuCard(menu: menu);
              },
            );
          }

          // Si el estado es DishesLoaded u otro, mostrar loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMenuForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Menú'),
      ),
    );
  }

  void _showMenuForm(BuildContext context, MenuEntity? menu) {
    final menuBloc = context.read<MenuBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: menuBloc,
        child: MenuFormBottomSheet(menu: menu),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuEntity menu;

  const _MenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showMenuDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (menu.tipo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            menu.tipo!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: menu.estaActivo ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      menu.estaActivo ? 'Activo' : 'Inactivo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (menu.descripcion != null) ...[
                const SizedBox(height: 8),
                Text(
                  menu.descripcion!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'S/ ${menu.precioPorPersona.toStringAsFixed(2)} / persona',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (menu.margen != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.trending_up, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${menu.margen!.toStringAsFixed(1)}% margen',
                      style: TextStyle(fontSize: 12, color: Colors.green[600]),
                    ),
                  ],
                ],
              ),
              if (menu.dishes != null && menu.dishes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${menu.dishes!.length} platos incluidos',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMenuDetail(BuildContext context) {
    final menuBloc = context.read<MenuBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: menuBloc,
        child: MenuDetailBottomSheet(menu: menu),
      ),
    );
  }
}
