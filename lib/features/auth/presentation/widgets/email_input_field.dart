import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final bool enabled;

  const EmailInputField({
    super.key,
    required this.controller,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.whiteAlmost),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: AppColors.grayLight),
        errorText: errorText,
        filled: true,
        fillColor: AppColors.grayDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grayLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.yellowPastel, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu correo electrónico';
        }
        if (!Validators.isValidEmail(value)) {
          return 'Por favor ingresa un correo electrónico válido';
        }
        return null;
      },
    );
  }
}
