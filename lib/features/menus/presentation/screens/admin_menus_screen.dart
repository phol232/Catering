import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../widgets/menu_list_tab.dart';

class AdminMenusScreen extends StatefulWidget {
  const AdminMenusScreen({super.key});

  @override
  State<AdminMenusScreen> createState() => _AdminMenusScreenState();
}

class _AdminMenusScreenState extends State<AdminMenusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadMenusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Menús')),
      body: BlocListener<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is MenuError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const MenuListTab(),
      ),
    );
  }
}
