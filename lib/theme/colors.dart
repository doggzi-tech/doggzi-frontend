import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppColors {
  // Oranges
  static const Color orange500 = Color(0xFFC01212);
  static const Color orange400 = Color(0xFFF63522);
  static const Color orange300 = Color(0xFFFF8063);
  static const Color orange200 = Color(0xFFFFA097);
  static const Color orange100 = Color(0xFFFF7E70);

  static const Color brown = Color(0xffEB9E7A);
  static const Color brown500 = Color(0xffAF773F);

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
