import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_decorations.dart';

/// MediRelay 커스텀 버튼 위젯
/// React 버전의 btn 클래스들을 Flutter로 완전 구현
enum CustomButtonType {
  primary,     // React의 .btn-primary
  secondary,   // React의 .btn-secondary  
  outlined,    // 테두리만 있는 버튼
  text,        // 텍스트만 있는 버튼
  fab,         // 플로팅 액션 버튼 (녹음 버튼용)
}

enum CustomButtonSize {
  small,       // React의 작은 버튼
  medium,      // React의 기본 버튼  
  large,       // React의 큰 버튼
}

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  // ✅ 버튼 크기별 설정
  ButtonConfig get _config {
    switch (widget.size) {
      case CustomButtonSize.small:
        return ButtonConfig(
          height: widget.height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.buttonSmall,
          iconSize: 16,
        );
      case CustomButtonSize.medium:
        return ButtonConfig(
          height: widget.height ?? 54,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
          iconSize: 20,
        );
      case CustomButtonSize.large:
        return ButtonConfig(
          height: widget.height ?? 64,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: AppTextStyles.buttonLarge,
          iconSize: 24,
        );
    }
  }

  // ✅ 버튼 타입별 스타일
  ButtonStyle get _buttonStyle {
    final config = _config;
    final isDisabled = widget.isDisabled || widget.isLoading;

    switch (widget.type) {
      case CustomButtonType.primary:
        return _buildPrimaryStyle(config, isDisabled);
      case CustomButtonType.secondary:
        return _buildSecondaryStyle(config, isDisabled);
      case CustomButtonType.outlined:
        return _buildOutlinedStyle(config, isDisabled);
      case CustomButtonType.text:
        return _buildTextStyle(config, isDisabled);
      case CustomButtonType.fab:
        return _buildFabStyle(config, isDisabled);
    }
  }

  ButtonStyle _buildPrimaryStyle(ButtonConfig config, bool isDisabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled 
          ? AppColors.border 
          : (widget.backgroundColor ?? AppColors.primary),
      foregroundColor: isDisabled 
          ? AppColors.textTertiary 
          : (widget.textColor ?? AppColors.textOnPrimary),
      textStyle: config.textStyle,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
      ),
      padding: config.padding,
      minimumSize: Size(widget.width ?? 0, config.height),
      elevation: isDisabled ? 0 : 2,
      shadowColor: AppColors.shadowLight,
    );
  }

  ButtonStyle _buildSecondaryStyle(ButtonConfig config, bool isDisabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled 
          ? AppColors.surfaceVariant 
          : (widget.backgroundColor ?? AppColors.surface),
      foregroundColor: isDisabled 
          ? AppColors.textTertiary 
          : (widget.textColor ?? AppColors.textPrimary),
      textStyle: config.textStyle,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
        side: BorderSide(
          color: isDisabled 
              ? AppColors.border 
              : (widget.borderColor ?? AppColors.border),
          width: 1,
        ),
      ),
      padding: config.padding,
      minimumSize: Size(widget.width ?? 0, config.height),
      elevation: 0,
    );
  }

  ButtonStyle _buildOutlinedStyle(ButtonConfig config, bool isDisabled) {
    return OutlinedButton.styleFrom(
      foregroundColor: isDisabled 
          ? AppColors.textTertiary 
          : (widget.textColor ?? AppColors.primary),
      textStyle: config.textStyle,
      side: BorderSide(
        color: isDisabled 
            ? AppColors.border 
            : (widget.borderColor ?? AppColors.primary),
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
      ),
      padding: config.padding,
      minimumSize: Size(widget.width ?? 0, config.height),
    );
  }

  ButtonStyle _buildTextStyle(ButtonConfig config, bool isDisabled) {
    return TextButton.styleFrom(
      foregroundColor: isDisabled 
          ? AppColors.textTertiary 
          : (widget.textColor ?? AppColors.primary),
      textStyle: config.textStyle,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusMedium,
      ),
      padding: config.padding,
      minimumSize: Size(widget.width ?? 0, config.height),
    );
  }

  ButtonStyle _buildFabStyle(ButtonConfig config, bool isDisabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDisabled 
          ? AppColors.border 
          : (widget.backgroundColor ?? AppColors.primary),
      foregroundColor: isDisabled 
          ? AppColors.textTertiary 
          : (widget.textColor ?? AppColors.textOnPrimary),
      shape: const CircleBorder(),
      padding: EdgeInsets.zero,
      minimumSize: Size(config.height, config.height),
      elevation: isDisabled ? 0 : 4,
      shadowColor: AppColors.shadowMedium,
    );
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
    final isDisabled = widget.isDisabled || widget.isLoading;
    
    Widget button;

    if (widget.type == CustomButtonType.fab) {
      button = _buildFabButton(isDisabled);
    } else {
      button = _buildRegularButton(isDisabled);
    }

    return GestureDetector(
      onTapDown: isDisabled ? null : _onTapDown,
      onTapUp: isDisabled ? null : _onTapUp,
      onTapCancel: isDisabled ? null : _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }

  Widget _buildRegularButton(bool isDisabled) {
    return SizedBox(
      width: widget.width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: _buttonStyle,
        child: widget.isLoading 
            ? _buildLoadingContent()
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildFabButton(bool isDisabled) {
    return SizedBox(
      width: _config.height,
      height: _config.height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: _buttonStyle,
        child: widget.isLoading 
            ? _buildLoadingContent()
            : _buildFabContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: _config.iconSize),
          const SizedBox(width: 8),
          Text(widget.text),
        ],
      );
    }
    return Text(widget.text);
  }

  Widget _buildFabContent() {
    if (widget.icon != null) {
      return Icon(widget.icon, size: _config.iconSize);
    }
    return Text(
      widget.text,
      style: _config.textStyle.copyWith(fontSize: _config.iconSize),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.type == CustomButtonType.primary 
                  ? AppColors.textOnPrimary 
                  : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(widget.text),
      ],
    );
  }
}

// ✅ 버튼 설정 클래스
class ButtonConfig {
  const ButtonConfig({
    required this.height,
    required this.padding,
    required this.textStyle,
    required this.iconSize,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
}