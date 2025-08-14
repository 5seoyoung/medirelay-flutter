import 'package:flutter/material.dart';

class ChatbotPage extends StatelessWidget {
  final String patientId;
  final String patientName;
  final String room;
  final String diagnosis;

  ChatbotPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.room,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$patientName - AI 챗봇'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'AI 챗봇 페이지',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('곧 구현될 예정입니다!'),
          ],
        ),
      ),
    );
  }
}