// lib/main.dart - 2단계: 페이지 네비게이션 추가
import 'package:flutter/material.dart';

void main() {
  runApp(const MediRelayApp());
}

class MediRelayApp extends StatelessWidget {
  const MediRelayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediRelay Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2), // React 버전과 동일한 파란색
        ),
        useMaterial3: true,
      ),
      home: const LandingPage(), // 랜딩 페이지로 시작
      debugShowCheckedModeBanner: false,
    );
  }
}

// 랜딩 페이지 (React 버전과 유사)
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 상단 로고 영역 (React 버전과 동일)
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 로고
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF4A90E2), width: 3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A90E2).withOpacity(0.1),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        size: 60,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 앱 타이틀
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Medi',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                          TextSpan(
                            text: 'Relay',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // 설명
                    const Text(
                      'AI 기반 차세대 간호기록 시스템',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // 기능 소개 카드들 (React 버전과 유사)
              Expanded(
                flex: 3,
                child: ListView(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.mic,
                      title: '음성 차팅',
                      description: '말하면 기록 끝!\nAI가 자동으로 간호기록을 작성',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.smart_toy,
                      title: 'AI 분류 & 요약',
                      description: 'V/S, I/O 자동 분류\n활력징후, 투입/배출량 등을 자동 분류',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      icon: Icons.chat,
                      title: '스마트 질의응답',
                      description: '자연어 처리\n"오늘 체온이 어떻게 됐나요?" 같은 질문 가능',
                    ),
                  ],
                ),
              ),
              
              // 시작하기 버튼 (React 버전과 동일한 스타일)
              Container(
                width: double.infinity,
                height: 54,
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: ElevatedButton(
                  onPressed: () {
                    // 로그인 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '🚀 로그인하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // 데모 안내 (React 버전과 동일)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  border: Border.all(color: const Color(0xFF4A90E2), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      '📱 Flutter 데모 버전',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'React에서 Flutter로 성공적으로 마이그레이션!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: const Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 로그인 페이지 (React 버전과 유사)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final employeeId = _employeeIdController.text.trim();
    final password = _passwordController.text.trim();

    if (employeeId.isEmpty || password.isEmpty) {
      _showMessage('사번과 비밀번호를 모두 입력해주세요.');
      return;
    }

    // 데모 계정 확인 (React 버전과 동일)
    if ((employeeId == 'N001' && password == '1234') ||
        (employeeId == 'demo' && password == 'demo')) {
      _showMessage('로그인 성공! 환자 목록으로 이동합니다.');
      
      // 환자 목록 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PatientsPage()),
      );
    } else {
      _showMessage('사번 또는 비밀번호가 올바르지 않습니다.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4A90E2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4A90E2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '간호사 로그인',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // 로고
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF4A90E2), width: 3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.medical_services,
                  size: 50,
                  color: Color(0xFF4A90E2),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // 로그인 폼
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF4A90E2), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // 사번 입력
                    TextField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: '사번',
                        hintText: 'N001',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 비밀번호 입력
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '비밀번호',
                        hintText: '••••',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '🔑 로그인',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 데모 계정 안내
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      '📱 데모 계정',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ID: demo / PW: demo\nID: N001 / PW: 1234',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 환자 목록 페이지 (간단한 버전)
class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          '환자 목록',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF4A90E2)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 100,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(height: 24),
            Text(
              '🎉 2단계 네비게이션 성공!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '페이지 간 이동이 정상 작동합니다!\n로그아웃 버튼으로 처음으로 돌아갈 수 있어요.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}