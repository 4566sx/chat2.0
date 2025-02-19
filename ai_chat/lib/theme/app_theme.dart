import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final notoSerif = GoogleFonts.notoSerif();
    
    return ThemeData(
      fontFamily: notoSerif.fontFamily,
      primaryColor: AppColors.navy,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        hintStyle: GoogleFonts.notoSerif(
          color: AppColors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 0;
              return 2;
            },
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.notoSerif(
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.notoSerif(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
} 