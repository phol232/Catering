import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SettingsScreen extends StatelessWidget {
  final bool showAppBar;

  const SettingsScreen({super.key, this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: showAppBar
          ? AppBar(
              title: const Text('Configuración'),
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.whiteAlmost,
            )
          : null,
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Perfil Section
          _buildSectionHeader('Perfil'),
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Editar perfil',
            subtitle: 'Actualiza tu información personal',
            onTap: () {
              // TODO: Navigate to profile edit screen
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'Cambiar contraseña',
            subtitle: 'Actualiza tu contraseña',
            onTap: () {
              // TODO: Navigate to change password screen
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),

          const Divider(color: AppColors.grayLight, height: 32),

          // Notificaciones Section
          _buildSectionHeader('Notificaciones'),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notificaciones push',
            subtitle: 'Recibe alertas de eventos y cotizaciones',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
              activeTrackColor: AppColors.yellowPastel,
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.email_outlined,
            title: 'Notificaciones por email',
            subtitle: 'Recibe actualizaciones por correo',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Implement email notification toggle
              },
              activeTrackColor: AppColors.yellowPastel,
            ),
          ),

          const Divider(color: AppColors.grayLight, height: 32),

          // Apariencia Section
          _buildSectionHeader('Apariencia'),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode_outlined,
            title: 'Tema oscuro',
            subtitle: 'Actualmente activado',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement theme toggle
              },
              activeTrackColor: AppColors.yellowPastel,
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () {
              // TODO: Show language picker
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),

          const Divider(color: AppColors.grayLight, height: 32),

          // Privacidad y Seguridad Section
          _buildSectionHeader('Privacidad y Seguridad'),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Política de privacidad',
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: 'Términos y condiciones',
            onTap: () {
              // TODO: Show terms and conditions
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),

          const Divider(color: AppColors.grayLight, height: 32),

          // Soporte Section
          _buildSectionHeader('Soporte'),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'Centro de ayuda',
            onTap: () {
              // TODO: Navigate to help center
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.feedback_outlined,
            title: 'Enviar comentarios',
            onTap: () {
              // TODO: Show feedback form
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Próximamente')));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.0',
            onTap: () {
              // TODO: Show about dialog
              showAboutDialog(
                context: context,
                applicationName: 'CaterPro',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 CaterPro',
              );
            },
          ),

          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.yellowPastel,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grayLight, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.whiteAlmost, fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: AppColors.grayLight, fontSize: 14),
            )
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: AppColors.grayLight)
              : null),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.grayDark,
        title: const Text(
          '¿Cerrar sesión?',
          style: TextStyle(color: AppColors.whiteAlmost),
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(color: AppColors.grayLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.grayLight),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go('/home');
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
