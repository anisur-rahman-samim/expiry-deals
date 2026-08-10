import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide light theme: Material 3, brand orange, iOS-friendly page transitions.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.mainColor,
      brightness: Brightness.light,
    );

    final scheme = baseScheme.copyWith(
      surface: AppColors.bgColor,
      onSurface: AppColors.textColor,
      primary: AppColors.mainColor,
      onPrimary: Colors.white,
      secondary: AppColors.secColor,
      surfaceContainerHighest: AppColors.white,
      outline: AppColors.grayLight,
      outlineVariant: AppColors.grayLight.withValues(alpha: 0.6),
    );

    final textTheme = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: AppColors.textColor,
      displayColor: AppColors.textColor,
    );

    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.black,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.grayLight.withValues(alpha: 0.6)),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grayLight.withValues(alpha: 0.8),
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        dragHandleColor: AppColors.gray.withValues(alpha: 0.5),
        dragHandleSize: const Size(36, 4),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.mainColor,
        thumbColor: AppColors.mainColor,
        overlayColor: AppColors.mainColor.withValues(alpha: 0.12),
        inactiveTrackColor: AppColors.grayLight,
        trackHeight: 4,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
