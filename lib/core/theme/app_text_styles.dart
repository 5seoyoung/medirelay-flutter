import 'package:flutter/material.dart';
import 'app_colors.dart';

/// MediRelay 앱의 타이포그래피 시스템
/// React 버전의 폰트 크기/굵기를 Flutter로 변환
class AppTextStyles {
  AppTextStyles._();

  // ✅ Font Family (한국어 최적화)
  static const String primaryFont = 'Pretendard';
  static const String fallbackFont = 'SF Pro Display';
  
  // ✅ Base Text Style
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: primaryFont,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.normal,
    height: 1.5, // line-height: 1.5
  );
  
  // ✅ Headers (React의 h1, h2, h3에 해당)
  static TextStyle get h1 => _baseStyle.copyWith(
    fontSize: 28,           // React: 28px
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static TextStyle get h2 => _baseStyle.copyWith(
    fontSize: 24,           // React: 24px
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
  );
  
  static TextStyle get h3 => _baseStyle.copyWith(
    fontSize: 20,           // React: 20px
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static TextStyle get h4 => _baseStyle.copyWith(
    fontSize: 18,           // React: 18px
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  // ✅ Body Text (본문)
  static TextStyle get bodyLarge => _baseStyle.copyWith(
    fontSize: 16,           // React: 16px
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  
  static TextStyle get bodyMedium => _baseStyle.copyWith(
    fontSize: 14,           // React: 14px - 가장 많이 사용
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => _baseStyle.copyWith(
    fontSize: 12,           // React: 12px
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  
  // ✅ Labels (라벨, 캡션)
  static TextStyle get labelLarge => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static TextStyle get labelMedium => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
  
  static TextStyle get labelSmall => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // ✅ Button Text (버튼 전용)
  static TextStyle get buttonLarge => _baseStyle.copyWith(
    fontSize: 18,           // React: 큰 버튼
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static TextStyle get buttonMedium => _baseStyle.copyWith(
    fontSize: 16,           // React: 기본 버튼
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static TextStyle get buttonSmall => _baseStyle.copyWith(
    fontSize: 14,           // React: 작은 버튼
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  
  // ✅ Specialized Styles (의료 앱 특화)
  static TextStyle get patientName => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static TextStyle get medicalData => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()], // 숫자 정렬
  );
  
  static TextStyle get timestamp => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  // ✅ Color Variants (색상 변형)
  static TextStyle get onPrimary => _baseStyle.copyWith(
    color: AppColors.textOnPrimary,
  );
  
  static TextStyle get secondary => _baseStyle.copyWith(
    color: AppColors.textSecondary,
  );
  
  static TextStyle get tertiary => _baseStyle.copyWith(
    color: AppColors.textTertiary,
  );
  
  static TextStyle get error => _baseStyle.copyWith(
    color: AppColors.error,
  );
  
  static TextStyle get success => _baseStyle.copyWith(
    color: AppColors.success,
  );
  
  // ✅ Utility Methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}