import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../domain/entities/demo_account.dart';

/// 데모 계정 선택 위젯
/// React 버전의 데모 계정 섹션을 Flutter로 완전 구현
class DemoAccountSelector extends StatefulWidget {
  const DemoAccountSelector({
    super.key,
    required this.demoAccounts,
    required this.onAccountSelected,
  });

  final List<DemoAccount> demoAccounts;
  final Function(DemoAccount) onAccountSelected;

  @override
  State<DemoAccountSelector> createState() => _DemoAccountSelectorState();
}

class _DemoAccountSelectorState extends State<DemoAccountSelector> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardPrimary.copyWith(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildAccountGrid(),
          const SizedBox(height: 16),
          _buildFooterNote(),
        ],
      ),
    );
  }

  // ✅ 헤더
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('📱', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          '데모 계정 (빠른 로그인)',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ✅ 계정 그리드 (React 버전과 동일한 2x2 레이아웃)
  Widget _buildAccountGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemCount: widget.demoAccounts.length > 4 ? 4 : widget.demoAccounts.length,
      itemBuilder: (context, index) {
        final account = widget.demoAccounts[index];
        return _buildAccountButton(account, index);
      },
    );
  }

  // ✅ 계정 버튼 (React 버전과 동일한 스타일)
  Widget _buildAccountButton(DemoAccount account, int index) {
    final isSelected = _selectedIndex == index;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: (details) {
              setState(() => _selectedIndex = index);
              _controller.forward();
            },
            onTapUp: (details) {
              _controller.reverse();
              // 약간의 딜레이 후 선택
              Future.delayed(const Duration(milliseconds: 100), () {
                widget.onAccountSelected(account);
                setState(() => _selectedIndex = null);
              });
            },
            onTapCancel: () {
              _controller.reverse();
              setState(() => _selectedIndex = null);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.primaryDark : AppColors.primary,
                  width: 2,
                ),
                borderRadius: AppDecorations.radiusMedium,
                boxShadow: isSelected ? AppDecorations.shadowMedium : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppDecorations.radiusMedium,
                  onTap: () => widget.onAccountSelected(account),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 이름
                        Text(
                          account.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        
                        // 사번
                        Text(
                          account.employeeId,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 푸터 안내 (React 버전과 동일)
  Widget _buildFooterNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppDecorations.radiusSmall,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            '모든 계정 비밀번호: 1234',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '(demo 계정은 demo/demo)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ✅ 확장된 데모 계정 버튼 (상세 정보 포함)
class DetailedDemoAccountButton extends StatefulWidget {
  const DetailedDemoAccountButton({
    super.key,
    required this.account,
    required this.onSelected,
  });

  final DemoAccount account;
  final VoidCallback onSelected;

  @override
  State<DetailedDemoAccountButton> createState() => _DetailedDemoAccountButtonState();
}

class _DetailedDemoAccountButtonState extends State<DetailedDemoAccountButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
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

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: AppDecorations.cardDefault,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppDecorations.radiusMedium,
            onTap: widget.onSelected,
            onTapDown: (details) {
              setState(() => _isPressed = true);
              _controller.forward();
            },
            onTapUp: (details) {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _controller.reverse();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 아바타
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      widget.account.name.substring(0, 1),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.account.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.account.employeeId} • ${widget.account.department}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 화살표
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}