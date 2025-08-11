import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/landing_page.dart';

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
    );
  }
}