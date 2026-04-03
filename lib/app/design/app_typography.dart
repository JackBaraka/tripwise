import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(Color textColor) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    final headings = GoogleFonts.soraTextTheme();

    TextStyle withColor(TextStyle? style) =>
        (style ?? const TextStyle()).copyWith(color: textColor);

    return TextTheme(
      displayLarge: withColor(headings.displayLarge).copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.15,
      ),
      headlineMedium: withColor(headings.headlineMedium).copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.2,
      ),
      titleMedium: withColor(base.titleMedium).copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      bodyMedium: withColor(base.bodyMedium).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      labelSmall: withColor(base.labelSmall).copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}

