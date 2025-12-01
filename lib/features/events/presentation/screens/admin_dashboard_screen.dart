import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../quotes/presentation/screens/admin_quotes_screen.dart';
import '../../../menus/presentation/bloc/menu_bloc.dart';
import '../../../menus/presentation/screens/admin_menus_screen.dart';
import '../../../reports/presentation/screens/reports_screen.dart';
import '../../../reports/presentation/bloc/report_bloc.dart';
import 'event_management_screen.dart';
import 'config_screen.dart';

/// Admin dashboard screen with bottom navigation
/// Provides access to Eventos, Pedidos, Menús, and Config sections
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  /// Current selected tab index
  int _currentIndex = 0;

  /// List of screens for each tab
  /// Maintains state of each section when switching tabs
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const EventManagementScreen(),
      const AdminQuotesScreen(),
      BlocProvider(
        create: (context) => getIt<MenuBloc>(),
        child: const AdminMenusScreen(),
      ),
      BlocProvider(
        create: (context) => getIt<ReportBloc>(),
        child: const ReportsScreen(),
      ),
      const ConfigScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.grayDark,
        selectedItemColor: AppColors.yellowPastel,
        unselectedItemColor: AppColors.grayLight,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menús',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}
