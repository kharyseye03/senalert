import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3:             true,
      brightness:               Brightness.light,
      scaffoldBackgroundColor:  AppColors.background,
      fontFamily:               'DMSans',

      // ── ColorScheme ──────────────────────────────
      colorScheme: const ColorScheme.light(
        primary:    AppColors.primary,
        onPrimary:  AppColors.textOnPrimary,
        secondary:  AppColors.info,
        onSecondary:AppColors.textOnPrimary,
        surface:    AppColors.surface,
        onSurface:  AppColors.textPrimary,
        error:      AppColors.primary,
        onError:    AppColors.textOnPrimary,
      ),

      // ── TextTheme ────────────────────────────────
      textTheme: const TextTheme(
        displayLarge:  AppTextStyles.heroTitle,
        displayMedium: AppTextStyles.screenTitle,
        displaySmall:  AppTextStyles.cardTitle,
        bodyLarge:     AppTextStyles.bodySemiBold,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.buttonLabel,
        labelSmall:    AppTextStyles.sectionLabel,
      ),

      // ── AppBar ───────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor:    AppColors.primary,
        foregroundColor:    AppColors.textOnPrimary,
        elevation:          0,
        centerTitle:        false,
        titleTextStyle:     AppTextStyles.screenTitle,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:          Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // ── ElevatedButton ───────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize:     const Size(double.infinity, 52),
          shape:           const RoundedRectangleBorder(
            borderRadius: AppRadius.btn,
          ),
          elevation:       0,
          textStyle:       AppTextStyles.buttonLabel,
          padding:         const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical:   AppSpacing.lg,
          ),
        ),
      ),

      // ── OutlinedButton ───────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize:     const Size(double.infinity, 52),
          side:            const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
          shape:           const RoundedRectangleBorder(
            borderRadius: AppRadius.btn,
          ),
          textStyle:       AppTextStyles.buttonLabel.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // ── TextButton ───────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle:       AppTextStyles.bodySemiBold,
        ),
      ),

      // ── InputDecoration ──────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:         true,
        fillColor:      AppColors.surface,
        hintStyle:      AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(
            color: AppColors.borderFocus,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: AppColors.primary),
        ),
      ),

      // ── Card ─────────────────────────────────────
      cardTheme: CardThemeData(
        color:     AppColors.surface,
        elevation: 0,
        margin:    EdgeInsets.zero,
        shape:     RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side:         const BorderSide(color: AppColors.border),
        ),
      ),

      // ── BottomNavigationBar ──────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:      AppColors.surface,
        selectedItemColor:    AppColors.primary,
        unselectedItemColor:  AppColors.textHint,
        elevation:            0,
        type:                 BottomNavigationBarType.fixed,
        selectedLabelStyle:   TextStyle(
          fontFamily: 'DMSans',
          fontSize:   11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'DMSans',
          fontSize:   11,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Divider ──────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     AppColors.border,
        thickness: 1,
        space:     0,
      ),

      // ── SnackBar ─────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:  AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}