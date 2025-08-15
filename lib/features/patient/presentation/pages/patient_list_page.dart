import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final String room;
  final String diagnosis;
  final String status;
  final String age;
  final String gender;
  final String admissionDate;

  Patient({
    required this.id,
    required this.name,
    required this.room,
    required this.diagnosis,
    required this.status,
    required this.age,
    required this.gender,
    required this.admissionDate,
  });
}

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 샘플 환자 데이터
  final List<Patient> allPatients = [
    Patient(
      id: '1',
      name: '김영희',
      room: '301호',
      diagnosis: '당뇨병성 케토산증',
      status: 'stable',
      age: '65',
      gender: '여',
      admissionDate: '2025-01-10',
    ),
    Patient(
      id: '2',
      name: '박철수',
      room: '302호',
      diagnosis: '급성 심근경색',
      status: 'critical',
      age: '58',
      gender: '남',
      admissionDate: '2025-01-12',
    ),
    Patient(
      id: '3',
      name: '이미나',
      room: '303호',
      diagnosis: '폐렴',
      status: 'stable',
      age: '42',
      gender: '여',
      admissionDate: '2025-01-08',
    ),
  ];

  List<Patient> get filteredPatients {
    if (searchQuery.isEmpty) {
      return allPatients;
    }
    return allPatients
        .where((patient) =>
            patient.name.contains(searchQuery) ||
            patient.room.contains(searchQuery) ||
            patient.diagnosis.contains(searchQuery))
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'critical':
        return const Color(0xFFE74C3C);
      case 'serious':
        return const Color(0xFFF39C12);
      case 'stable':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'critical':
        return '위험';
      case 'serious':
        return '주의';
      case 'stable':
        return '안정';
      default:
        return '관찰';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '환자 목록',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4A90E2)),
            onPressed: () {
              // 알림 기능 구현 예정
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF7F8C8D)),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/landing');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: '환자명, 병실, 진단명으로 검색...',
                hintStyle: TextStyle(color: Color(0xFFBDC3C7)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF4A90E2)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),

          // 환자 목록
          Expanded(
            child: filteredPatients.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Color(0xFFBDC3C7),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      return _buildPatientCard(patient);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 환자명과 상태
            Row(
              children: [
                Expanded(
                  child: Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(patient.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    getStatusText(patient.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: getStatusColor(patient.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 병실 정보
            Text(
              patient.room,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // 환자 기본 정보
            Row(
              children: [
                Text(
                  '${patient.age}세',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBDC3C7),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  patient.gender,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBDC3C7),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '입원일: ${patient.admissionDate}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 진단명
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '진단명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7F8C8D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient.diagnosis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2C3E50),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 액션 버튼들
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/nursing-record/${patient.id}',
                            arguments: {
                              'patientName': patient.name,
                              'room': patient.room,
                              'diagnosis': patient.diagnosis,
                            },
                          );
                        },
                        icon: const Icon(Icons.description, size: 18),
                        label: const Text('간호기록지'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // 음성 차팅으로 이동 (임시)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text('${patient.name} 음성차팅')),
                                body: const Center(child: Text('음성차팅 페이지\n(구현 예정)')),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mic, size: 18),
                        label: const Text('음성차팅'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4A90E2),
                          side: const BorderSide(color: Color(0xFF4A90E2)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // 인계장 버튼
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/handover/${patient.id}',
                            arguments: {
                              'patientName': patient.name,
                              'room': patient.room,
                              'diagnosis': patient.diagnosis,
                            },
                          );
                        },
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text('인계장'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF27AE60),
                          side: const BorderSide(color: Color(0xFF27AE60)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // AI 챗봇 버튼
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/chatbot/${patient.id}',
                            arguments: {
                              'patientName': patient.name,
                              'room': patient.room,
                              'diagnosis': patient.diagnosis,
                            },
                          );
                        },
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('AI 질의응답'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF9B59B6),
                          side: const BorderSide(color: Color(0xFF9B59B6)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}