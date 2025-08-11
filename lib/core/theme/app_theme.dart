import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_decorations.dart';

/// MediRelay 앱의 전체 테마 시스템
/// React 버전의 디자인을 Material Design 3로 완전 구현
class AppTheme {
  AppTheme._();

  // ✅ Light Theme (메인 테마)
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,
    
    // ✅ Typography (React의 폰트 시스템과 동일)
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineMedium: AppTextStyles.h4,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // ✅ AppBar Theme (헤더 스타일)
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h3,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shape: const Border(
        bottom: BorderSide(color: AppColors.border, width: 1),
      ),
    ),

    // ✅ Button Themes (React의 btn 클래스들과 매핑)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMedium,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(0, 54), // 터치 친화적 최소 높이
        elevation: 2,
        shadowColor: AppColors.shadowLight,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMedium,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(0, 48),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        side: const BorderSide(color: AppColors.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMedium,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(0, 54),
      ),
    ),

    // ✅ Input Field Theme (React의 form-input과 동일)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: AppDecorations.radiusMedium,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppDecorations.radiusMedium,
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppDecorations.radiusMedium,
        borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppDecorations.radiusMedium,
        borderSide: const BorderSide(color: AppColors.borderError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textTertiary,
      ),
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ✅ Card Theme (React의 patient-card와 동일)
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    ),

    // ✅ Bottom Navigation Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // ✅ Floating Action Button Theme (녹음 버튼)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusRounded,
      ),
    ),

    // ✅ Dialog Theme
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
      ),
      titleTextStyle: AppTextStyles.h3,
      contentTextStyle: AppTextStyles.bodyMedium,
    ),

    // ✅ Chip Theme (카테고리 태그)
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      selectedColor: AppColors.primary.withOpacity(0.1),
      labelStyle: AppTextStyles.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusRounded,
      ),
      side: const BorderSide(color: AppColors.border, width: 1),
    ),

    // ✅ List Tile Theme
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: AppTextStyles.bodyLarge,
      subtitleTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    ),

    // ✅ Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // ✅ Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceVariant,
    ),

    // ✅ Scaffold Background
    scaffoldBackgroundColor: AppColors.background,
    
    // ✅ Visual Density (터치 친화적)
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // ✅ Dark Theme (추후 구현)
  static ThemeData get darkTheme => lightTheme.copyWith(
    // 다크 모드는 나중에 구현
    brightness: Brightness.dark,
  );

  // ✅ Utility Methods
  static ThemeData getTheme({bool isDark = false}) {
    return isDark ? darkTheme : lightTheme;
  }

  // ✅ Custom Extensions (편의 메서드)
  static BoxDecoration cardDecoration({bool isElevated = false}) {
    return isElevated 
        ? AppDecorations.cardElevated 
        : AppDecorations.cardDefault;
  }

  static EdgeInsetsGeometry get defaultPadding => 
      const EdgeInsets.all(24);

  static EdgeInsetsGeometry get cardPadding => 
      const EdgeInsets.all(20);

  static EdgeInsetsGeometry get buttonPadding => 
      const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static EdgeInsetsGeometry get inputPadding => 
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  static EdgeInsetsGeometry get listPadding => 
      const EdgeInsets.symmetric(horizontal: 24, vertical: 8);
}