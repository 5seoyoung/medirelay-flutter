import 'package:flutter/material.dart';

/// MediRelay 앱의 컬러 팔레트
/// React 버전의 디자인과 동일한 색상 체계
class AppColors {
  AppColors._();

  // ✅ Primary Colors (React 버전과 동일)
  static const Color primary = Color(0xFF4A90E2);       // #4A90E2 - 메인 파란색
  static const Color primaryDark = Color(0xFF357ABD);   // hover/pressed 상태
  static const Color primaryLight = Color(0xFF6BA3E8); // 밝은 버전
  
  // ✅ Background Colors
  static const Color background = Color(0xFFFAFAFA);    // #FAFAFA - 메인 배경
  static const Color surface = Color(0xFFFFFFFF);       // #FFFFFF - 카드 배경
  static const Color surfaceVariant = Color(0xFFF8F9FA); // 섹션 배경
  
  // ✅ Text Colors
  static const Color textPrimary = Color(0xFF333333);   // #333333 - 메인 텍스트
  static const Color textSecondary = Color(0xFF666666); // #666666 - 서브 텍스트
  static const Color textTertiary = Color(0xFF999999);  // #999999 - 비활성 텍스트
  static const Color textOnPrimary = Color(0xFFFFFFFF); // 흰색 (버튼 텍스트)
  
  // ✅ Border Colors
  static const Color border = Color(0xFFE8E8E8);        // #E8E8E8 - 기본 테두리
  static const Color borderFocus = Color(0xFF4A90E2);   // 포커스 테두리
  static const Color borderError = Color(0xFFFF6B6B);   // 에러 테두리
  
  // ✅ Status Colors
  static const Color success = Color(0xFF50C878);       // 성공 (녹색)
  static const Color warning = Color(0xFFFF9800);       // 경고 (주황색)
  static const Color error = Color(0xFFFF6B6B);         // 에러 (빨간색)
  static const Color info = Color(0xFF2196F3);          // 정보 (파란색)
  
  // ✅ Specialized Colors (의료 앱 특화)
  static const Color vitalsign = Color(0xFF4CAF50);     // 활력징후 (녹색)
  static const Color medication = Color(0xFFFF5722);    // 투약 (주황색)
  static const Color observation = Color(0xFF9C27B0);   // 관찰 (보라색)
  static const Color handover = Color(0xFF00BCD4);      // 인계 (청록색)
  
  // ✅ Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A90E2), Color(0xFF667EEA)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
  );
  
  // ✅ Shadow Colors
  static const Color shadowLight = Color(0x1A4A90E2);   // 연한 그림자
  static const Color shadowMedium = Color(0x334A90E2);  // 중간 그림자
  static const Color shadowDark = Color(0x4D4A90E2);    // 진한 그림자
  
  // ✅ Opacity Variants
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color textWithOpacity(double opacity) => textPrimary.withOpacity(opacity);
  
  // ✅ Color Getters (Material Design 호환)
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    onPrimary: textOnPrimary,
    secondary: primaryLight,
    surface: surface,
    background: background,
    error: error,
  );
  
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    // 다크모드는 추후 구현
  );
}