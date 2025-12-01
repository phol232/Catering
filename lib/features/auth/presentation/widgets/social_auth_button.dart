import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SocialAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.grayDark,
          side: const BorderSide(color: AppColors.grayLight, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.yellowPastel,
                  ),
                ),
              )
            : Image.asset(
                'assets/images/google_logo.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.g_mobiledata,
                    size: 24,
                    color: AppColors.whiteAlmost,
                  );
                },
              ),
        label: Text(
          'Continue with Google',
          style: TextStyle(
            color: isLoading ? AppColors.grayLight : AppColors.whiteAlmost,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
