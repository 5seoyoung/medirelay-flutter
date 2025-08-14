import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 근무조 열거형
enum Shift { day, evening, night }

// 인계장 모델
class Handover {
  final String id;
  final String patientId;
  final String date;
  final Shift shift;
  final String content;
  final DateTime createdAt;
  final int recordCount;

  Handover({
    required this.id,
    required this.patientId,
    required this.date,
    required this.shift,
    required this.content,
    required this.createdAt,
    required this.recordCount,
  });
}

class HandoverPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String room;
  final String diagnosis;

  const HandoverPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.room,
    required this.diagnosis,
  });

  @override
  State<HandoverPage> createState() => _HandoverPageState();
}

class _HandoverPageState extends State<HandoverPage> {
  DateTime selectedDate = DateTime.now();
  Shift selectedShift = Shift.day;
  String handoverContent = '';
  bool isGenerating = false;
  String? error;
  List<Map<String, dynamic>> nursingRecords = [];

  @override
  void initState() {
    super.initState();
    _loadNursingRecords();
    _loadExistingHandover();
  }

  // 샘플 간호기록 로드 (실제로는 로컬 스토리지나 API에서)
  void _loadNursingRecords() {
    // 샘플 데이터 - 실제로는 해당 날짜의 간호기록을 가져와야 함
    nursingRecords = [
      {
        'id': '1',
        'category': 'V/S',
        'content': '혈압 130/80, 맥박 75, 체온 36.8℃',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'priority': '보통',
      },
      {
        'id': '2',
        'category': '투약',
        'content': '진통제 투여 후 통증 완화됨',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'priority': '높음',
      },
      {
        'id': '3',
        'category': '관찰',
        'content': '수면상태 양호, 식사량 보통',
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        'priority': '낮음',
      },
    ];
  }

  // 기존 인계장 로드
  void _loadExistingHandover() {
    // 실제로는 로컬 스토리지나 서버에서 가져와야 함
    final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
    // 샘플 기존 인계장이 있다고 가정
    if (dateString == DateFormat('yyyy-MM-dd').format(DateTime.now()) && 
        selectedShift == Shift.day) {
      setState(() {
        handoverContent = '''환자 상태 안정적으로 유지 중

주요 사항:
• 활력징후: 혈압 130/80, 맥박 75, 체온 36.8℃로 정상 범위
• 통증 관리: 진통제 투여 후 통증 완화 효과적
• 수면/식사: 수면상태 양호, 식사량 보통

특이사항:
• 특이사항 없음

다음 근무조 인계사항:
• 4시간 후 통증 재평가 필요
• 활력징후 지속 모니터링''';
      });
    }
  }

  // 날짜 변경 시 기록 및 인계장 다시 로드
  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      handoverContent = '';
    });
    _loadNursingRecords();
    _loadExistingHandover();
  }

  // 근무조 변경 시 인계장 다시 로드
  void _onShiftChanged(Shift newShift) {
    setState(() {
      selectedShift = newShift;
      handoverContent = '';
    });
    _loadExistingHandover();
  }

  // AI 인계장 생성 (실제로는 OpenAI API 호출)
  Future<void> _generateHandover() async {
    if (nursingRecords.isEmpty) {
      setState(() {
        error = '선택한 날짜에 간호기록이 없습니다.';
      });
      return;
    }

    setState(() {
      isGenerating = true;
      error = null;
    });

    try {
      // 실제로는 OpenAI API 호출
      await Future.delayed(const Duration(seconds: 2)); // 시뮬레이션

      final generatedContent = _generateSampleHandover();
      
      setState(() {
        handoverContent = generatedContent;
        isGenerating = false;
      });

      _showSnackBar('인계장이 생성되었습니다!', isSuccess: true);
    } catch (e) {
      setState(() {
        error = '인계장 생성 중 오류가 발생했습니다: $e';
        isGenerating = false;
      });
    }
  }

  // 샘플 인계장 생성
  String _generateSampleHandover() {
    final shiftName = _getShiftName(selectedShift);
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    
    return '''$shiftName 근무 인계장 ($dateStr)

환자명: ${widget.patientName}
병실: ${widget.room}
진단명: ${widget.diagnosis}

주요 간호기록 요약:
${nursingRecords.map((record) => '• ${record['category']}: ${record['content']}').join('\n')}

환자 상태:
• 전반적으로 안정적인 상태 유지
• 통증 조절 잘 되고 있음
• 활력징후 정상 범위 내

특이사항:
• 특이사항 없음

다음 근무조 인계사항:
• 정기적인 활력징후 체크
• 통증 상태 지속 관찰
• 수분 섭취량 모니터링

기록 작성자: 시스템 자동 생성
총 ${nursingRecords.length}개 기록 기반
생성 시간: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}''';
  }

  // 인계장 저장
  void _saveHandover() {
    if (handoverContent.isEmpty) {
      _showSnackBar('저장할 인계장 내용이 없습니다.', isSuccess: false);
      return;
    }

    // 실제로는 로컬 스토리지나 서버에 저장
    _showSnackBar('인계장이 저장되었습니다!', isSuccess: true);
  }

  // 인계장 공유 (간단한 텍스트 공유)
  void _shareHandover() {
    if (handoverContent.isEmpty) {
      _showSnackBar('공유할 인계장 내용이 없습니다.', isSuccess: false);
      return;
    }

    // 실제로는 share_plus 패키지 등을 사용해서 공유
    _showSnackBar('공유 기능은 곧 구현될 예정입니다.', isSuccess: false);
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getShiftName(Shift shift) {
    switch (shift) {
      case Shift.day:
        return '주간 (08:00-16:00)';
      case Shift.evening:
        return '오후 (16:00-24:00)';
      case Shift.night:
        return '야간 (24:00-08:00)';
    }
  }

  String _getShiftDisplayName(Shift shift) {
    switch (shift) {
      case Shift.day:
        return '주간';
      case Shift.evening:
        return '오후';
      case Shift.night:
        return '야간';
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    
    if (picked != null && picked != selectedDate) {
      _onDateChanged(picked);
    }
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
          '인계장',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.description, color: Color(0xFF4A90E2)),
            onPressed: () {
              // 간호기록지로 이동
              Navigator.pop(context);
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
                  Text(
                    '진단명: ${widget.diagnosis}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 날짜 및 근무조 선택
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  const Text(
                    '인계장 설정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 날짜 선택
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, 
                                 color: Color(0xFF4A90E2), size: 20),
                      const SizedBox(width: 12),
                      const Text('날짜:', 
                                style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                              style: const TextStyle(
                                color: Color(0xFF4A90E2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 근무조 선택
                  Row(
                    children: [
                      const Icon(Icons.access_time, 
                                 color: Color(0xFF4A90E2), size: 20),
                      const SizedBox(width: 12),
                      const Text('근무조:', 
                                style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<Shift>(
                          value: selectedShift,
                          onChanged: (Shift? newShift) {
                            if (newShift != null) {
                              _onShiftChanged(newShift);
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: Shift.values.map((Shift shift) {
                            return DropdownMenuItem<Shift>(
                              value: shift,
                              child: Text(_getShiftDisplayName(shift)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 기록 정보
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, 
                                   color: Color(0xFF6C757D), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('yyyy-MM-dd').format(selectedDate)} / '
                          '${_getShiftName(selectedShift)} / '
                          '기록 ${nursingRecords.length}개',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 에러 표시
          if (error != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                border: Border.all(color: const Color(0xFFFFCDD2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, 
                             color: Color(0xFFC62828), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: const TextStyle(
                        color: Color(0xFFC62828),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // 생성 버튼
          if (nursingRecords.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isGenerating ? null : _generateHandover,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('AI 인계장 생성 중...'),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 20),
                          SizedBox(width: 8),
                          Text('AI 인계장 자동 생성'),
                        ],
                      ),
              ),
            ),

          const SizedBox(height: 16),

          // 인계장 내용
          if (handoverContent.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.description, 
                                     color: Color(0xFF4A90E2)),
                          const SizedBox(width: 8),
                          const Text(
                            '인계장 내용',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.share, 
                                           color: Color(0xFF6C757D)),
                            onPressed: _shareHandover,
                          ),
                        ],
                      ),
                    ),
                    
                    // 내용
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            handoverContent,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // 액션 버튼들
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saveHandover,
                              icon: const Icon(Icons.save),
                              label: const Text('저장'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF4A90E2),
                                side: const BorderSide(
                                    color: Color(0xFF4A90E2)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _shareHandover,
                              icon: const Icon(Icons.download),
                              label: const Text('다운로드'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF4A90E2),
                                side: const BorderSide(
                                    color: Color(0xFF4A90E2)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (nursingRecords.isEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: Color(0xFFBDC3C7),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '선택한 날짜에 간호기록이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '먼저 간호기록을 작성해주세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBDC3C7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: 64,
                      color: Color(0xFFBDC3C7),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'AI 인계장을 생성해보세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '선택한 날짜의 간호기록을 바탕으로\nAI가 자동으로 인계장을 작성해드립니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBDC3C7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}