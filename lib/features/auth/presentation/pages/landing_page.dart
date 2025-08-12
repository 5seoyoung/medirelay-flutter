import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../shared/widgets/custom_button.dart';
import 'login_page.dart';

/// MediRelay 랜딩 페이지
/// React 버전의 디자인을 Flutter로 완전 구현
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // 현재 사용자 상태 (추후 상태관리로 변경)
  bool _isLoggedIn = false;
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkLoginStatus();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 애니메이션 시작 (약간의 딜레이 후)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  void _checkLoginStatus() {
    // TODO: 실제 로그인 상태 확인 로직
    // SharedPreferences나 상태관리에서 가져오기
    setState(() {
      _isLoggedIn = false; // 임시
      _currentUser = null;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ✅ 이벤트 핸들러들
  void _navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _navigateToPatients() {
    // TODO: 환자 목록 페이지로 네비게이션 (임시 메시지)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🏥 환자 목록 페이지로 이동 (구현 예정)'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _currentUser = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👋 로그아웃 되었습니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ✅ 테스트용 로그인 상태 토글
  void _toggleLoginStatus() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
      if (_isLoggedIn) {
        _currentUser = {
          'name': '김간호사',
          'department': '내과 병동',
          'position': '간호사',
        };
      } else {
        _currentUser = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    if (_isLoggedIn && _currentUser != null) ...[
                      _buildWelcomeCard(),
                      const SizedBox(height: 16),
                    ],
                    _buildMainLogoCard(),
                    const SizedBox(height: 16),
                    _buildFeatureCards(),
                    const SizedBox(height: 32),
                    _buildStartButton(),
                    const SizedBox(height: 32),
                    _buildDemoNotice(),
                    const SizedBox(height: 24),
                    _buildVersionInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ 헤더 (React의 header와 동일)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 로고
        GestureDetector(
          onTap: _toggleLoginStatus, // 테스트용: 로고 클릭하면 로그인 상태 토글
          child: Row(
            children: [
              Text(
                'Medi',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Relay',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        // 로그인 버튼
        _isLoggedIn 
            ? CustomButton(
                text: '로그아웃',
                onPressed: _handleLogout,
                type: CustomButtonType.text,
                size: CustomButtonSize.small,
              )
            : CustomButton(
                text: '로그인',
                onPressed: _navigateToLogin,
                type: CustomButtonType.text,
                size: CustomButtonSize.small,
              ),
      ],
    );
  }

  // ✅ 환영 메시지 카드 (로그인 시에만 표시)
  Widget _buildWelcomeCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: AppDecorations.cardDefault,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('👋', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(
                    '안녕하세요, ${_currentUser?['name'] ?? '사용자'}님!',
                    style: AppTextStyles.patientName,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentUser?['department'] ?? ''} • ${_currentUser?['position'] ?? ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 메인 로고 카드 (React 버전과 동일)
  Widget _buildMainLogoCard() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: AppDecorations.cardDefault,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 로고 컨테이너
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.primary, width: 3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 32,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 브랜드명
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Medi',
                        style: AppTextStyles.patientName.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Relay',
                        style: AppTextStyles.patientName.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // 슬로건
                  Text(
                    'AI 기반 차세대 간호기록 시스템',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 기능 소개 카드들 (React 버전과 동일)
  Widget _buildFeatureCards() {
    final features = [
      FeatureCardData(
        emoji: '🎙️',
        title: '음성 차팅',
        capability: '말하면 기록 끝!',
        description: '말로 기록하면 AI가 자동으로 간호기록을 작성해드립니다.',
      ),
      FeatureCardData(
        emoji: '🤖',
        title: 'AI 분류 & 요약',
        capability: 'V/S, I/O 분류',
        description: '활력징후, 투입/배출량 등을 자동 분류하고 인계장을 생성합니다.',
      ),
      FeatureCardData(
        emoji: '💬',
        title: '스마트 질의응답',
        capability: '자연어 처리',
        description: '"오늘 체온이 어떻게 됐나요?" 같은 자연어 질문이 가능합니다.',
      ),
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 200)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: AppDecorations.cardDefault,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            feature.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            feature.title,
                            style: AppTextStyles.h4,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            '기능',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            feature.capability,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feature.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // ✅ 시작하기 버튼 (React 버전과 동일 로직)
  Widget _buildStartButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(
            opacity: value,
            child: CustomButton(
              text: _isLoggedIn ? '🏥 업무 시작하기' : '🚀 로그인하기',
              onPressed: _isLoggedIn ? _navigateToPatients : _navigateToLogin,
              type: CustomButtonType.primary,
              size: CustomButtonSize.large,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }

  // ✅ 데모 안내 (React 버전과 동일)
  Widget _buildDemoNotice() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                border: Border.all(color: AppColors.primary, width: 2),
                borderRadius: AppDecorations.radiusMedium,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '📱 데모 버전',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'OpenAI API 시뮬레이션 모드로 동작합니다',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 버전 정보 (React 버전과 동일)
  Widget _buildVersionInfo() {
    return Text(
      'MediRelay v1.0 • Made with Flutter for Healthcare',
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textTertiary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ✅ 기능 카드 데이터 모델
class FeatureCardData {
  const FeatureCardData({
    required this.emoji,
    required this.title,
    required this.capability,
    required this.description,
  });

  final String emoji;
  final String title;
  final String capability;
  final String description;
}