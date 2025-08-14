import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/patient/presentation/pages/patient_list_page.dart';

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
    );
  }
}