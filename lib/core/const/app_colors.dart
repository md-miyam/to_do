import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // Brand Colors

  static const Color primary = Color(0xFF00685F);
  static const Color primaryDark = Color(0xFF6BD8CB);

  static const Color secondary = Color(0xFF575E70);
  static const Color secondaryDark = Color(0xFF4FDBC8);

  static const Color tertiary = Color(0xFF555C6A);
  static const Color tertiaryDark = Color(0xFFFFB59A);

  // ===========================================================================
  // Light Theme

  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightSurface = Color(0xFFEEEEEE);

  static const Color lightText = Color(0xFF1A1C1C);
  static const Color lightSubText = Color(0xFF3D4947);

  static const Color lightBorder = Color(0xFFBCC9C6);
  static const Color lightDivider = Color(0xFFBCC9C6);

  static const Color lightInput = Color(0xFFF3F3F3);
  static const Color lightShadow = Color(0x14000000);

  // Optional Surface Levels
  static const Color lightSurfaceLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceLow = Color(0xFFF3F3F3);
  static const Color lightSurfaceHigh = Color(0xFFE8E8E8);
  static const Color lightSurfaceHighest = Color(0xFFE2E2E2);

  // ===========================================================================
  // Dark Theme

  static const Color darkBackground = Color(0xFF131313);
  static const Color darkSurface = Color(0xFF201F1F);

  static const Color darkText = Color(0xFFE5E2E1);
  static const Color darkSubText = Color(0xFFBCC9C6);

  static const Color darkBorder = Color(0xFF3D4947);
  static const Color darkDivider = Color(0xFF3D4947);

  static const Color darkInput = Color(0xFF1C1B1B);
  static const Color darkShadow = Color(0x33000000);

  // Optional Surface Levels
  static const Color darkSurfaceLowest = Color(0xFF0E0E0E);
  static const Color darkSurfaceLow = Color(0xFF1C1B1B);
  static const Color darkSurfaceHigh = Color(0xFF2A2A2A);
  static const Color darkSurfaceHighest = Color(0xFF353534);

  // ===========================================================================
  // Status Colors

  static const Color success = Color(0xFF6BD8CB);
  static const Color warning = Color(0xFFFFB59A);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color info = Color(0xFF89F5E7);

  // ===========================================================================
  // Theme Helpers

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color text(BuildContext context) =>
      isDark(context) ? darkText : lightText;

  static Color subText(BuildContext context) =>
      isDark(context) ? darkSubText : lightSubText;

  static Color border(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color divider(BuildContext context) =>
      isDark(context) ? darkDivider : lightDivider;

  static Color input(BuildContext context) =>
      isDark(context) ? darkInput : lightInput;

  static Color shadow(BuildContext context) =>
      isDark(context) ? darkShadow : lightShadow;

  static Color brand(BuildContext context) =>
      isDark(context) ? primaryDark : primary;
}