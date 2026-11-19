import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Barlow Condensed 800 Huruf Kapital untuk judul besar & angka
  static TextStyle displayLarge = GoogleFonts.barlowCondensed(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    height: 1.05,
    letterSpacing: 0.5,
  );

  static TextStyle displayMedium = GoogleFonts.barlowCondensed(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    height: 1.1,
  );

  static TextStyle statNumber = GoogleFonts.barlowCondensed(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.accentOrange,
  );

  // Inter untuk teks umum & UI
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle labelButton = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  // Caveat untuk aksen tulisan tangan
  static TextStyle handwrittenNote = GoogleFonts.caveat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.accentOrange,
  );
}