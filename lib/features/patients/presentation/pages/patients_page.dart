import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 간단한 환자 목록 페이지 (임시)
class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: '🏠 홈',
                    onPressed: () => Navigator.of(context).pop(),
                    type: CustomButtonType.text,
                    size: CustomButtonSize.small,
                  ),
                  Text(
                    '환자 목록',
                    style: AppTextStyles.h3,
                  ),
                  CustomButton(
                    text: '📷 QR',
                    onPressed: () {},
                    type: CustomButtonType.text,
                    size: CustomButtonSize.small,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 임시 메시지
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏥', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 24),
                      Text(
                        '환자 목록 페이지',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '곧 완성될 예정입니다!',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}