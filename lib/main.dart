import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/patient/presentation/pages/patient_list_page.dart';
import 'features/handover/presentation/pages/handover_page.dart';
import 'features/chatbot/presentation/pages/chatbot_page.dart';

void main() {
  runApp(const MediRelayApp());
}

class MediRelayApp extends StatelessWidget {
  const MediRelayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediRelay - AI 간호기록 시스템',
      theme: AppTheme.lightTheme,
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/patient-list': (context) => const PatientListPage(),
      },
      onGenerateRoute: (settings) {
        // 동적 라우팅 처리
        if (settings.name!.startsWith('/handover/')) {
          final patientId = settings.name!.split('/')[2];
          final args = settings.arguments as Map<String, dynamic>?;
          
          return MaterialPageRoute(
            builder: (context) => HandoverPage(
              patientId: patientId,
              patientName: args?['patientName'] ?? '환자',
              room: args?['room'] ?? '병실',
              diagnosis: args?['diagnosis'] ?? '진단명',
            ),
          );
        }
        
        // AI 챗봇 페이지 라우팅
        if (settings.name!.startsWith('/chatbot/')) {
          final patientId = settings.name!.split('/')[2];
          final args = settings.arguments as Map<String, dynamic>?;
          
          return MaterialPageRoute(
            builder: (context) => ChatbotPage(
              patientId: patientId,
              patientName: args?['patientName'] ?? '환자',
              room: args?['room'] ?? '병실',
              diagnosis: args?['diagnosis'] ?? '진단명',
            ),
          );
        }
        
        return null;
      },
    );
  }
}