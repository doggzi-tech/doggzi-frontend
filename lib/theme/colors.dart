import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppColors {
  // Oranges
  static const Color orange500 = Color(0xFFC01212);
  static const Color orange400 = Color(0xFFF63522);
  static const Color orange300 = Color(0xFFFF8063);
  static const Color orange200 = Color(0xFFFFA097);
  static const Color orange100 = Color(0xFFFF7E70);

  // Greens
  static const Color green400 = Color(0xFF279165);
  static const Color green300 = Color(0xFF15BE77);
  static const Color green200 = Color(0xFF12E48C);
  static const Color green100 = Color(0xFFA4F8D5);

  // Dark Greys
  static const Color darkGrey500 = Color(0xFF181818);
  static const Color darkGrey400 = Color(0xFF303030);
  static const Color darkGrey300 = Color(0xFF727272);
  static const Color darkGrey200 = Color(0xFFAEAEAE);
  static const Color darkGrey100 = Color(0xFFE1E0E0);

  // Light Greys
  static const Color lightGrey500 = Color(0xFFBDBDBD);
  static const Color lightGrey400 = Color(0xFFD1D1D6);
  static const Color lightGrey300 = Color(0xFFD9D9D9);
  static const Color lightGrey200 = Color(0xFFEFEFEC);
  static const Color lightGrey100 = Color(0xFFFFFFFF); // white
}

class OldAppColors {
  // ─── MAPPED OLD PALETTE ─────────────────────────────────────────────────────

  // Primary
  static const Color primaryOrange = Color(0xFFF75322); // from doggziOrange
  static const Color accentYellow = Color(0xFFFFE500);

  // Backgrounds
  static const Color brown = Color(0xEB9E7A99);

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
