import 'package:flutter/material.dart';
import 'app_colors.dart';

/// MediRelay 앱의 데코레이션 시스템
/// React 버전의 CSS 스타일을 Flutter BoxDecoration으로 변환
class AppDecorations {
  AppDecorations._();

  // ✅ Border Radius (React의 border-radius)
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusRounded = BorderRadius.all(Radius.circular(50));

  // ✅ Box Shadows (React의 box-shadow)
  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x1A4A90E2),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x334A90E2),
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x4D4A90E2),
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  // ✅ Card Decorations (React의 patient-card 스타일)
  static BoxDecoration get cardDefault => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.border, width: 1),
    boxShadow: shadowLight,
  );

  static BoxDecoration get cardElevated => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.border, width: 1),
    boxShadow: shadowMedium,
  );

  static BoxDecoration get cardPrimary => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.primary, width: 2),
    boxShadow: shadowLight,
  );

  // ✅ Button Decorations
  static BoxDecoration get buttonPrimary => BoxDecoration(
    color: AppColors.primary,
    borderRadius: radiusMedium,
    boxShadow: shadowLight,
  );

  static BoxDecoration get buttonSecondary => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.border, width: 1),
  );

  static BoxDecoration get buttonOutlined => BoxDecoration(
    color: Colors.transparent,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.primary, width: 2),
  );

  // ✅ Input Field Decorations (React의 form-input 스타일)
  static InputDecoration inputDefault({
    required String hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: radiusMedium,
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radiusMedium,
      borderSide: const BorderSide(color: AppColors.border, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radiusMedium,
      borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radiusMedium,
      borderSide: const BorderSide(color: AppColors.borderError, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  // ✅ Container Decorations (다양한 용도)
  static BoxDecoration get surfaceContainer => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.border, width: 1),
  );

  static BoxDecoration get backgroundContainer => BoxDecoration(
    color: AppColors.surfaceVariant,
    borderRadius: radiusMedium,
  );

  static BoxDecoration get primaryContainer => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: radiusMedium,
    boxShadow: shadowLight,
  );

  // ✅ Specialized Decorations (의료 앱 특화)
  static BoxDecoration get recordCard => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.border, width: 1),
    boxShadow: shadowLight,
  );

  static BoxDecoration patientCard({bool isSelected = false}) => BoxDecoration(
    color: AppColors.surface,
    borderRadius: radiusMedium,
    border: Border.all(
      color: isSelected ? AppColors.primary : AppColors.border,
      width: isSelected ? 2 : 1,
    ),
    boxShadow: isSelected ? shadowMedium : shadowLight,
  );

  static BoxDecoration categoryChip({required Color color}) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: radiusRounded,
    border: Border.all(color: color, width: 1),
  );

  // ✅ Animation Decorations (hover, press 효과)
  static BoxDecoration buttonHovered(BoxDecoration original) => original.copyWith(
    boxShadow: shadowMedium,
  );

  static BoxDecoration buttonPressed(BoxDecoration original) => original.copyWith(
    boxShadow: shadowLight,
  );

  // ✅ Status Decorations
  static BoxDecoration get successContainer => BoxDecoration(
    color: AppColors.success.withOpacity(0.1),
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.success, width: 1),
  );

  static BoxDecoration get warningContainer => BoxDecoration(
    color: AppColors.warning.withOpacity(0.1),
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.warning, width: 1),
  );

  static BoxDecoration get errorContainer => BoxDecoration(
    color: AppColors.error.withOpacity(0.1),
    borderRadius: radiusMedium,
    border: Border.all(color: AppColors.error, width: 1),
  );
}