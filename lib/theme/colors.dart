import 'package:flutter/material.dart';

class AppColors {
  // ─── MAPPED OLD PALETTE ─────────────────────────────────────────────────────

  // Primary
  static const Color primaryOrange = Color(0xFFF75322); // from doggziOrange
  static const Color accentYellow = Color(0xFFFFE500);

  // Backgrounds
  static const Color lightBackground = Color(0xFFEEF5FF);

  // Text
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMedium = Color(0xFF828282);

  // Feedback
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color greenHighlight = Color(0xFF27AE60);

  // Dividers & states
  static const Color dividerGray = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFE0E0E0);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // ─── EXTRA NEW COLORS ───────────────────────────────────────────────────────

  // Primary Blues
  static const Color primaryBlue = Color(0xFF007AFE);
  static const Color secondaryBlue = Color(0xFF0062E0);

  // Accents
  static const Color accentOrange = Color(0xFFFFB703);
  static const Color accentPurple = Color(0xFF9B51E0);

  // Greys & Blacks
  static const Color black = Color(0xFF000000);

  // Custom “Doggzi” Colors
  static const Color doggziRed = Color(0xFFFF3C3C);
  static const Color doggziPurple = Color(0xFF7C3AED);
  static const Color doggziPink = Color(0xFFFF2D55);

  // Gradients
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFFB7ABFD), Color(0xFF6D6697)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA453D6), Color(0xFF562B70)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF15BE77), Color(0xFF0A5837)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
