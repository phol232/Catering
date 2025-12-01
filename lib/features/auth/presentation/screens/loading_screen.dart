import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Loading screen displayed during authentication and other async operations
/// Shows the CaterPro logo, spinner, and loading text using brand colors
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo container with brand colors
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.yellowPastel,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 60,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 32),
            // App name
            const Text(
              'CaterPro',
              style: TextStyle(
                color: AppColors.yellowPastel,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Loading spinner
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowPastel),
            ),
            const SizedBox(height: 16),
            // Loading text
            const Text(
              'Cargando...',
              style: TextStyle(color: AppColors.grayLight, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
