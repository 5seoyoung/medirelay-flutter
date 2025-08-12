import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_decorations.dart';
import 'custom_button.dart';

/// 환자 카드 위젯
/// React 버전의 patient-card 클래스를 Flutter로 완전 구현
class PatientCard extends StatefulWidget {
  const PatientCard({
    super.key,
    required this.patientName,
    required this.birthDate,
    required this.room,
    required this.diagnosis,
    required this.department,
    required this.doctor,
    required this.admissionDate,
    required this.recentActivity,
    this.onTap,
    this.onRecordTap,
    this.onChartTap,
    this.onChatTap,
    this.isSelected = false,
  });

  final String patientName;
  final String birthDate;
  final String room;
  final String diagnosis;
  final String department;
  final String doctor;
  final String admissionDate;
  final String recentActivity;
  final VoidCallback? onTap;
  final VoidCallback? onRecordTap;
  final VoidCallback? onChartTap;
  final VoidCallback? onChatTap;
  final bool isSelected;

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: AppDecorations.patientCard(isSelected: widget.isSelected)
                .copyWith(
              boxShadow: AppDecorations.shadowLight.map((shadow) => 
                shadow.copyWith(
                  blurRadius: shadow.blurRadius * _shadowAnimation.value,
                  spreadRadius: shadow.spreadRadius * _shadowAnimation.value,
                )
              ).toList(),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: AppDecorations.radiusMedium,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPatientHeader(),
                      const SizedBox(height: 16),
                      _buildPatientInfo(),
                      const SizedBox(height: 16),
                      _buildRecentActivity(),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 환자 헤더 (이름, 생년월일)
  Widget _buildPatientHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.patientName,
                style: AppTextStyles.patientName,
              ),
              const SizedBox(height: 4),
              Text(
                widget.birthDate,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.surfaceVariant,
            borderRadius: AppDecorations.radiusSmall,
            border: Border.all(
              color: widget.isSelected 
                  ? AppColors.primary 
                  : AppColors.border,
              width: 1,
            ),
          ),
          child: Text(
            widget.room,
            style: AppTextStyles.labelMedium.copyWith(
              color: widget.isSelected 
                  ? AppColors.primary 
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 환자 정보 (진단, 과, 담당의, 입원일)
  Widget _buildPatientInfo() {
    return Column(
      children: [
        _buildInfoRow('진단명', widget.diagnosis),
        const SizedBox(height: 8),
        _buildInfoRow('현재 정보', '${widget.department}, ${widget.room}'),
        const SizedBox(height: 8),
        _buildInfoRow('담당의', widget.doctor),
        const SizedBox(height: 8),
        _buildInfoRow('입원일', widget.admissionDate),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 최근 활동
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppDecorations.radiusSmall,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '최신 기록: ${widget.recentActivity}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 액션 버튼들 (React 버전의 빠른 액션과 동일)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: '🎙️ 차팅',
            onPressed: widget.onRecordTap,
            type: CustomButtonType.primary,
            size: CustomButtonSize.small,
            backgroundColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: '📋 기록지',
            onPressed: widget.onChartTap,
            type: CustomButtonType.primary,
            size: CustomButtonSize.small,
            backgroundColor: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomButton(
            text: '💬 질문',
            onPressed: widget.onChatTap,
            type: CustomButtonType.primary,
            size: CustomButtonSize.small,
            backgroundColor: AppColors.error,
          ),
        ),
      ],
    );
  }
}

// ✅ 간단한 환자 카드 (리스트용)
class SimplePatientCard extends StatelessWidget {
  const SimplePatientCard({
    super.key,
    required this.patientName,
    required this.room,
    required this.diagnosis,
    this.onTap,
    this.isSelected = false,
  });

  final String patientName;
  final String room;
  final String diagnosis;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: AppDecorations.patientCard(isSelected: isSelected),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isSelected 
              ? AppColors.primary 
              : AppColors.surfaceVariant,
          child: Text(
            patientName.substring(0, 1),
            style: AppTextStyles.labelLarge.copyWith(
              color: isSelected 
                  ? AppColors.textOnPrimary 
                  : AppColors.textPrimary,
            ),
          ),
        ),
        title: Text(
          patientName,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '$room • $diagnosis',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: isSelected 
            ? Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
            : Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
      ),
    );
  }
}