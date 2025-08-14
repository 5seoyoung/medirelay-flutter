import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 간호기록 모델
class NursingRecord {
  final String id;
  final String category;
  final String content;
  final String priority;
  final DateTime timestamp;
  final String? keyFindings;
  final String? actionTaken;
  final String? patientResponse;
  final String? followUpNeeded;

  NursingRecord({
    required this.id,
    required this.category,
    required this.content,
    required this.priority,
    required this.timestamp,
    this.keyFindings,
    this.actionTaken,
    this.patientResponse,
    this.followUpNeeded,
  });
}

class NursingRecordPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String room;
  final String diagnosis;

  const NursingRecordPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.room,
    required this.diagnosis,
  });

  @override
  State<NursingRecordPage> createState() => _NursingRecordPageState();
}

class _NursingRecordPageState extends State<NursingRecordPage> {
  String selectedCategory = 'all';
  final List<String> categories = ['all', 'V/S', 'I/O', '투약', '관찰', '처치', '교육', '기타'];
  
  // 샘플 데이터 - 실제로는 API에서 가져올 예정
  final List<NursingRecord> sampleRecords = [
    NursingRecord(
      id: '1',
      category: 'V/S',
      content: '혈압 120/80, 맥박 72회/분, 체온 36.5℃ 측정. 정상 범위 내 안정적 유지.',
      priority: '보통',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      keyFindings: '활력징후 안정',
      actionTaken: '지속 모니터링',
    ),
    NursingRecord(
      id: '2',
      category: 'I/O',
      content: '수액 500ml 투여 완료, 소변량 300ml 배출. 수분 균형 양호.',
      priority: '낮음',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      keyFindings: '수분 균형 정상',
    ),
    NursingRecord(
      id: '3',
      category: '투약',
      content: '진통제 투여 후 환자가 통증 완화되었다고 표현함.',
      priority: '높음',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      keyFindings: '통증 완화 효과적',
      patientResponse: '통증이 많이 줄었어요',
      followUpNeeded: '4시간 후 통증 재평가 필요',
    ),
    NursingRecord(
      id: '4',
      category: '관찰',
      content: '환자 수면 패턴 개선, 야간 각성 횟수 감소.',
      priority: '보통',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      keyFindings: '수면의 질 향상',
    ),
  ];

  List<NursingRecord> get filteredRecords {
    if (selectedCategory == 'all') {
      return sampleRecords;
    }
    return sampleRecords.where((record) => record.category == selectedCategory).toList();
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'V/S':
        return const Color(0xFF4A90E2);
      case 'I/O':
        return const Color(0xFF50C878);
      case '투약':
        return const Color(0xFFFF6B6B);
      case '관찰':
        return const Color(0xFFFFB347);
      case '처치':
        return const Color(0xFF9B59B6);
      case '교육':
        return const Color(0xFF1ABC9C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  String getPriorityIcon(String priority) {
    switch (priority) {
      case '높음':
        return '🔴';
      case '보통':
        return '🟡';
      case '낮음':
        return '🟢';
      default:
        return '⚪';
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case '높음':
        return const Color(0xFFF44336);
      case '보통':
        return const Color(0xFFFF9800);
      case '낮음':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '간호기록지',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF4A90E2)),
            onPressed: () {
              // 음성 차팅 페이지로 이동
              Navigator.pushNamed(
                context, 
                '/voice-recording',
                arguments: {'patientId': widget.patientId}
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 환자 정보 카드
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.patientName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        widget.room,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '진단명: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.diagnosis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 카테고리 필터
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                final displayName = category == 'all' ? '전체' : category;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFFE8E8E8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 기록 목록
          Expanded(
            child: filteredRecords.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: Color(0xFFBDC3C7),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '아직 간호기록이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '+ 버튼을 눌러 음성 차팅을 시작하세요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFBDC3C7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      return _buildRecordCard(record);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context, 
            '/voice-recording',
            arguments: {'patientId': widget.patientId}
          );
        },
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildRecordCard(NursingRecord record) {
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
            // 헤더 (카테고리, 시간, 우선순위)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getCategoryColor(record.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatTime(record.timestamp),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      getPriorityIcon(record.priority),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: getPriorityColor(record.priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        record.priority,
                        style: TextStyle(
                          fontSize: 12,
                          color: getPriorityColor(record.priority),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 기록 내용
            Text(
              record.content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2C3E50),
                height: 1.5,
              ),
            ),

            // 추가 정보들 (있는 경우에만 표시)
            if (record.keyFindings != null) ...[
              const SizedBox(height: 12),
              _buildInfoSection('주요 발견사항', record.keyFindings!, const Color(0xFF3498DB)),
            ],

            if (record.actionTaken != null) ...[
              const SizedBox(height: 8),
              _buildInfoSection('수행한 간호행위', record.actionTaken!, const Color(0xFF27AE60)),
            ],

            if (record.patientResponse != null) ...[
              const SizedBox(height: 8),
              _buildInfoSection('환자 반응', record.patientResponse!, const Color(0xFF8E44AD)),
            ],

            if (record.followUpNeeded != null) ...[
              const SizedBox(height: 8),
              _buildInfoSection('추가 관찰 필요', record.followUpNeeded!, const Color(0xFFE74C3C)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF555555),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}