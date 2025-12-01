import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Menus screen - placeholder for menu management
class MenusScreen extends StatelessWidget {
  const MenusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          'Menús',
          style: TextStyle(color: AppColors.whiteAlmost),
        ),
      ),
      body: const Center(
        child: Text(
          'Próximamente',
          style: TextStyle(color: AppColors.grayLight, fontSize: 18),
        ),
      ),
    );
  }
}
