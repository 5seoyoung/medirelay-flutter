import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../widgets/demo_account_selector.dart';
import '../../domain/entities/demo_account.dart';
import '../../../patients/presentation/pages/patients_page.dart';

/// MediRelay 로그인 페이지
/// React 버전의 로그인 페이지를 Flutter로 완전 구현
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _employeeIdFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;

  // React 버전과 동일한 데모 계정들
  final List<DemoAccount> _demoAccounts = [
    DemoAccount(
      employeeId: 'N001',
      password: '1234',
      name: '김간호사',
      department: '내과 병동',
      position: '간호사',
    ),
    DemoAccount(
      employeeId: 'N002',
      password: '1234',
      name: '이간호사',
      department: '외과 병동',
      position: '수간호사',
    ),
    DemoAccount(
      employeeId: 'N003',
      password: '1234',
      name: '박간호사',
      department: '중환자실',
      position: '간호사',
    ),
    DemoAccount(
      employeeId: 'demo',
      password: 'demo',
      name: '데모간호사',
      department: '데모 병동',
      position: '간호사',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    _employeeIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
                    const SizedBox(height: 32),
                    _buildBrandingSection(),
                    const SizedBox(height: 32),
                    _buildLoginForm(),
                    const SizedBox(height: 24),
                    _buildDemoAccountsSection(),
                    const SizedBox(height: 32),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ 헤더 (홈으로 버튼)
  Widget _buildHeader() {
    return Row(
      children: [
        CustomButton(
          text: '🏠 홈으로',
          onPressed: _navigateToHome,
          type: CustomButtonType.text,
          size: CustomButtonSize.small,
        ),
        const Spacer(),
      ],
    );
  }

  // ✅ 브랜딩 섹션 (React 버전과 동일)
  Widget _buildBrandingSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                // 로고
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.primary, width: 3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    size: 32,
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
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Relay',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // 서브타이틀
                Text(
                  '간호사 로그인',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ 로그인 폼 (React 버전과 동일)
  Widget _buildLoginForm() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: AppDecorations.cardPrimary.copyWith(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmployeeIdField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty) ...[
                      _buildErrorMessage(),
                      const SizedBox(height: 20),
                    ],
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ 사번 입력 필드
  Widget _buildEmployeeIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사번',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _employeeIdController,
          focusNode: _employeeIdFocusNode,
          decoration: AppDecorations.inputDefault(
            hintText: 'N001',
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '사번을 입력해주세요';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            _passwordFocusNode.requestFocus();
          },
          onChanged: (value) {
            if (_errorMessage.isNotEmpty) {
              setState(() => _errorMessage = '');
            }
          },
        ),
      ],
    );
  }

  // ✅ 비밀번호 입력 필드
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: _obscurePassword,
          decoration: AppDecorations.inputDefault(
            hintText: '••••',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '비밀번호를 입력해주세요';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            _handleLogin();
          },
          onChanged: (value) {
            if (_errorMessage.isNotEmpty) {
              setState(() => _errorMessage = '');
            }
          },
        ),
      ],
    );
  }

  // ✅ 에러 메시지
  Widget _buildErrorMessage() {
    return Container(
      decoration: AppDecorations.errorContainer,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 로그인 버튼
  Widget _buildLoginButton() {
    return CustomButton(
      text: '🔑 로그인',
      onPressed: _isLoading ? null : _handleLogin,
      type: CustomButtonType.primary,
      size: CustomButtonSize.large,
      isLoading: _isLoading,
      width: double.infinity,
    );
  }

  // ✅ 데모 계정 섹션 (React 버전과 동일)
  Widget _buildDemoAccountsSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: DemoAccountSelector(
              demoAccounts: _demoAccounts,
              onAccountSelected: _handleDemoLogin,
            ),
          ),
        );
      },
    );
  }

  // ✅ 푸터
  Widget _buildFooter() {
    return Text(
      '보안을 위해 공용 기기에서는 로그아웃해주세요',
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textTertiary,
      ),
      textAlign: TextAlign.center,
    );
  }

  // ✅ 로그인 처리 (React 로직과 동일)
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final employeeId = _employeeIdController.text.trim();
      final password = _passwordController.text.trim();

      // 데모 계정 확인
      final account = _demoAccounts.firstWhere(
        (account) => 
            account.employeeId == employeeId && 
            account.password == password,
        orElse: () => DemoAccount.empty(),
      );

      if (account.employeeId.isNotEmpty) {
        // 로그인 성공
        await _performLogin(account);
      } else {
        // 로그인 실패
        setState(() {
          _errorMessage = '사번 또는 비밀번호가 올바르지 않습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '로그인 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ 데모 계정 로그인
  void _handleDemoLogin(DemoAccount account) {
    setState(() {
      _employeeIdController.text = account.employeeId;
      _passwordController.text = account.password;
      _errorMessage = '';
    });
    
    // 자동 로그인
    _performLogin(account);
  }

  // ✅ 로그인 수행
  Future<void> _performLogin(DemoAccount account) async {
    // TODO: 실제 로그인 로직 (상태관리, SharedPreferences 등)
    
    // 성공 메시지
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('👋 안녕하세요, ${account.name}님!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // 환자 목록 페이지로 이동 (구현 예정)
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToPatients();
      });
    }
  }

  // ✅ 네비게이션 메서드들
  void _navigateToHome() {
    Navigator.of(context).pop();
  }

  void _navigateToPatients() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PatientsPage(),
      ),
    );
  }
}

/// 위젯의 마지막에 DemoAccount 클래스 제거 (공통 파일로 분리했음)