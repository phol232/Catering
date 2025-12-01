import 'package:flutter/material.dart';

/// Brand color palette for CaterPro application
/// Defines the professional color scheme used throughout the app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  /// Primary brand color - Yellow Pastel
  /// Used for buttons, highlights, and primary actions
  static const Color yellowPastel = Color(0xFFF2F862);

  /// Main background color - Black
  /// Used as the primary background throughout the app
  static const Color black = Color(0xFF000000);

  /// Card and surface color - Gray Dark
  /// Used for cards, elevated surfaces over black background
  static const Color grayDark = Color(0xFF404040);

  /// Secondary text and muted elements - Gray Light
  /// Used for secondary text, outlines, and muted icons
  static const Color grayLight = Color(0xFFC1C1C1);

  /// Primary text color - White Almost
  /// Used for primary text on dark backgrounds
  static const Color whiteAlmost = Color(0xFFFEFEFE);

  /// Success color for positive states
  static const Color success = Color(0xFF4CAF50);

  /// Error color for error states
  static const Color error = Color(0xFFE53935);

  /// Warning color for warning states
  static const Color warning = Color(0xFFFFA726);

  /// Info color for informational states
  static const Color info = Color(0xFF29B6F6);
}
