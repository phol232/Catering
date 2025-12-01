import 'package:flutter/material.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

/// Config screen - wrapper for settings screen with AppBar
class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen(showAppBar: true);
  }
}
