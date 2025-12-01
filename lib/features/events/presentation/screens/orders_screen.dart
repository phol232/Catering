import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Orders screen - placeholder for order management
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          'Pedidos',
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
