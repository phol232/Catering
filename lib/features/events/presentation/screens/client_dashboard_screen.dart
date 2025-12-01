import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../quotes/presentation/screens/my_quotes_screen.dart';
import '../../../quotes/presentation/bloc/quote_bloc.dart';
import '../../../quotes/presentation/bloc/quote_event.dart';
import '../../../menus/presentation/screens/client_menus_screen.dart';
import '../../../menus/presentation/bloc/menu_bloc.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../../core/di/injection.dart';

/// Client dashboard screen
/// Shows client's orders, menus and settings
class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  int _currentIndex = 0;

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Mis Pedidos';
      case 1:
        return 'Menús';
      case 2:
        return 'Configuración';
      default:
        return 'CaterPro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/home');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [_buildMyOrdersTab(), _buildMenusTab(), _buildConfigTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Mis Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menús',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await context.push('/quotes/create');
                // Si se creó exitosamente, recargar las cotizaciones
                if (result == true && mounted) {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    context.read<QuoteBloc>().add(
                      LoadQuotesByClientEvent(authState.user.id),
                    );
                  }
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Pedido'),
            )
          : null,
    );
  }

  Widget _buildMyOrdersTab() {
    return MyQuotesScreen(
      onNavigateToMenus: (index) {
        setState(() => _currentIndex = index);
      },
    );
  }

  Widget _buildMenusTab() {
    return BlocProvider(
      create: (context) => getIt<MenuBloc>(),
      child: const ClientMenusScreen(),
    );
  }

  Widget _buildConfigTab() {
    return const SettingsScreen();
  }
}
