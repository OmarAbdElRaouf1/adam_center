import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import 'app_text_theme.dart';

abstract class AppThemeData {
  const AppThemeData._();

  static const String _fontFamily = 'Hacen';

  static const Color _lightScaffold = AppColors.scaffoldLight;

  static final TextTheme _baseTextTheme = TextTheme(
    bodyLarge: AppTextTheme.bodyLarge,
    bodyMedium: AppTextTheme.bodyMedium,
    bodySmall: AppTextTheme.bodySmall,
    labelLarge: AppTextTheme.labelLarge,
    labelMedium: AppTextTheme.labelMedium,
    labelSmall: AppTextTheme.labelSmall,
    titleLarge: AppTextTheme.titleLarge,
    titleMedium: AppTextTheme.titleMedium,
    titleSmall: AppTextTheme.titleSmall,
    displayLarge: AppTextTheme.displayLarge,
    displayMedium: AppTextTheme.displayMedium,
    displaySmall: AppTextTheme.displaySmall,
    headlineLarge: AppTextTheme.headlineLarge,
    headlineMedium: AppTextTheme.headlineMedium,
    headlineSmall: AppTextTheme.headlineSmall,
  );

  static TextTheme _textTheme(Color color) => _baseTextTheme.apply(
    bodyColor: color,
    displayColor: color,
    fontFamily: _fontFamily,
  );

  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? AppColors.primaryColor : null,
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.primaryColor.withValues(alpha: 0.4)
          : null,
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: _lightScaffold,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.primaryColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
      titleTextStyle: AppTextTheme.headlineLarge.copyWith(
        color: AppColors.primaryColor,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),

    textTheme: _textTheme(AppColors.primaryColor),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Color(0x33C79A3A),
      selectionHandleColor: AppColors.primaryColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      errorStyle: AppTextTheme.bodySmall.copyWith(
        color: Colors.red.shade700,
        fontSize: 12.sp,
      ),
    ),

    iconTheme: const IconThemeData(color: AppColors.primaryColor),

    cardTheme: const CardThemeData(color: Colors.white, elevation: 2),

    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),

    dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),

    switchTheme: _switchTheme,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.black,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      surface: AppColors.codGray,
      onSurface: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      surfaceTintColor: AppColors.black,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextTheme.headlineLarge.copyWith(color: Colors.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    textTheme: _textTheme(AppColors.primaryColor),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
      selectionColor: Color(0x33C79A3A),
      selectionHandleColor: AppColors.primaryColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      errorStyle: AppTextTheme.bodySmall.copyWith(
        color: Colors.redAccent,
        fontSize: 12.sp,
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.white),

    cardTheme: CardThemeData(color: AppColors.codGray, elevation: 2),

    dialogTheme: DialogThemeData(backgroundColor: AppColors.codGray),

    dividerTheme: const DividerThemeData(color: Colors.white12, thickness: 1),

    switchTheme: _switchTheme,
  );
}
