import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 간호기록 모델 (기존 nursing_record_model.dart와 통합)
class NursingRecord {
  final String id;
  final String patientId;
  final String category;
  final String content;
  final String priority;
  final DateTime timestamp;
  final String? keyFindings;
  final String? actionTaken;
  final String? patientResponse;
  final String? followUpNeeded;
  final String nurseName;

  NursingRecord({
    required this.id,
    required this.patientId,
    required this.category,
    required this.content,
    required this.priority,
    required this.timestamp,
    this.keyFindings,
    this.actionTaken,
    this.patientResponse,
    this.followUpNeeded,
    required this.nurseName,
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
  
  // 샘플 간호기록 데이터 (실제로는 API나 로컬 DB에서 가져올 예정)
  late List<NursingRecord> allRecords;

  @override
  void initState() {
    super.initState();
    _loadNursingRecords();
  }

  void _loadNursingRecords() {
    // 샘플 데이터 생성
    allRecords = [
      NursingRecord(
        id: '1',
        patientId: widget.patientId,
        category: 'V/S',
        content: '혈압 120/80mmHg, 맥박 72회/분, 호흡 18회/분, 체온 36.5℃',
        priority: '보통',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        keyFindings: '활력징후 정상 범위 유지',
        actionTaken: '지속적인 모니터링 실시',
        nurseName: '김간호사',
      ),
      NursingRecord(
        id: '2',
        patientId: widget.patientId,
        category: '투약',
        content: '진통제 (타이레놀 500mg) 경구 투여',
        priority: '높음',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        keyFindings: '투약 후 통증 완화 효과',
        actionTaken: '진통제 투여',
        patientResponse: '통증이 8점에서 4점으로 감소됨',
        followUpNeeded: '4시간 후 통증 재평가 필요',
        nurseName: '김간호사',
      ),
      NursingRecord(
        id: '3',
        patientId: widget.patientId,
        category: 'I/O',
        content: '수액 500ml 투여 완료, 소변량 300ml',
        priority: '보통',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        keyFindings: '수분 균형 양호',
        actionTaken: '수액 투여 및 배뇨량 측정',
        nurseName: '이간호사',
      ),
      NursingRecord(
        id: '4',
        patientId: widget.patientId,
        category: '관찰',
        content: '수술 부위 드레싱 상태 확인, 삼출물 없음',
        priority: '높음',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        keyFindings: '수술 부위 치유 양호',
        actionTaken: '드레싱 상태 점검',
        nurseName: '박간호사',
      ),
      NursingRecord(
        id: '5',
        patientId: widget.patientId,
        category: '교육',
        content: '퇴원 후 약물 복용법 및 생활 수칙 교육',
        priority: '보통',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        keyFindings: '환자 이해도 양호',
        actionTaken: '퇴원 교육 실시',
        patientResponse: '교육 내용 이해했다고 표현',
        nurseName: '최간호사',
      ),
      NursingRecord(
        id: '6',
        patientId: widget.patientId,
        category: '처치',
        content: '정맥 카테터 교체 및 삽입 부위 소독',
        priority: '높음',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        keyFindings: '카테터 삽입 성공, 감염 징후 없음',
        actionTaken: 'IV 카테터 교체',
        nurseName: '정간호사',
      ),
    ];
  }

  List<NursingRecord> get filteredRecords {
    List<NursingRecord> filtered = selectedCategory == 'all' 
        ? allRecords 
        : allRecords.where((record) => record.category == selectedCategory).toList();
    
    // 최신순으로 정렬
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (recordDate == today) {
      return '오늘 ${formatTime(dateTime)}';
    } else if (recordDate == today.subtract(const Duration(days: 1))) {
      return '어제 ${formatTime(dateTime)}';
    } else {
      return DateFormat('MM/dd HH:mm').format(dateTime);
    }
  }

  void _showRecordDetails(NursingRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 핸들바
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 헤더
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
                    formatDate(record.timestamp),
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

              const SizedBox(height: 20),

              // 상세 내용
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailSection('기록 내용', record.content, Icons.description),
                    
                    if (record.keyFindings != null)
                      _buildDetailSection('주요 발견사항', record.keyFindings!, Icons.search),
                    
                    if (record.actionTaken != null)
                      _buildDetailSection('수행한 간호행위', record.actionTaken!, Icons.medical_services),
                    
                    if (record.patientResponse != null)
                      _buildDetailSection('환자 반응', record.patientResponse!, Icons.record_voice_over),
                    
                    if (record.followUpNeeded != null)
                      _buildDetailSection('추가 관찰 필요', record.followUpNeeded!, Icons.flag, 
                          isImportant: true),
                    
                    _buildDetailSection('작성자', record.nurseName, Icons.person),
                  ],
                ),
              ),

              // 액션 버튼들
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('수정'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4A90E2),
                        side: const BorderSide(color: Color(0xFF4A90E2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('닫기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon, {bool isImportant = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isImportant ? const Color(0xFFFFF3E0) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: isImportant ? Border.all(color: const Color(0xFFFF9800)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon, 
                size: 18, 
                color: isImportant ? const Color(0xFFFF9800) : const Color(0xFF4A90E2)
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isImportant ? const Color(0xFFFF9800) : const Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2C3E50),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.patientName} - 간호기록지',
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.room} • ${filteredRecords.length}개 기록',
              style: const TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF4A90E2)),
            onPressed: () {
              // 새 기록 추가 (음성 차팅 페이지로 이동)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('음성 차팅 페이지로 이동합니다')),
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
                          '해당 카테고리의 간호기록이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '+ 버튼을 눌러 새 기록을 추가하세요',
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
          // 음성 차팅 페이지로 이동
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('음성 차팅 기능으로 새 기록을 추가할 수 있습니다')),
          );
        },
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildRecordCard(NursingRecord record) {
    return GestureDetector(
      onTap: () => _showRecordDetails(record),
      child: Container(
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
                    formatDate(record.timestamp),
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

              // 기록 내용 (요약)
              Text(
                record.content,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2C3E50),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 추가 정보 표시 (있는 경우)
              if (record.keyFindings != null || record.followUpNeeded != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (record.keyFindings != null) ...[
                      const Icon(Icons.search, size: 14, color: Color(0xFF4A90E2)),
                      const SizedBox(width: 4),
                      const Text(
                        '주요발견',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (record.keyFindings != null && record.followUpNeeded != null)
                      const SizedBox(width: 12),
                    if (record.followUpNeeded != null) ...[
                      const Icon(Icons.flag, size: 14, color: Color(0xFFFF9800)),
                      const SizedBox(width: 4),
                      const Text(
                        '추가관찰',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFF9800),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 8),

              // 작성자 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Color(0xFF95A5A6)),
                      const SizedBox(width: 4),
                      Text(
                        record.nurseName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF95A5A6),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFFBDC3C7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}