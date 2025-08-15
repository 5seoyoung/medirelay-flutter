import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;

// 녹음 상태
enum RecordingState { ready, recording, processing, completed, error }

// 처리된 간호기록 결과
class ProcessedRecord {
  final String id;
  final String category;
  final String content;
  final String priority;
  final DateTime timestamp;
  final String? keyFindings;
  final String? actionTaken;
  final String? patientResponse;
  final String? followUpNeeded;

  ProcessedRecord({
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

class VoiceRecordingPage extends StatefulWidget {
  final String patientId;
  final String? patientName;
  final String? room;
  final String? diagnosis;

  const VoiceRecordingPage({
    super.key,
    required this.patientId,
    this.patientName,
    this.room,
    this.diagnosis,
  });

  @override
  State<VoiceRecordingPage> createState() => _VoiceRecordingPageState();
}

class _VoiceRecordingPageState extends State<VoiceRecordingPage> 
    with TickerProviderStateMixin {
  
  RecordingState _state = RecordingState.ready;
  String _transcribedText = '';
  ProcessedRecord? _processedRecord;
  Duration _recordingDuration = Duration.zero;
  
  // 애니메이션 컨트롤러들
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  // 웹 음성 인식 관련
  html.SpeechRecognition? _speechRecognition;
  bool _isWebSpeechSupported = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkWebSpeechSupport();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  void _checkWebSpeechSupport() {
    try {
      // Check if SpeechRecognition is available
      _isWebSpeechSupported = js.context.hasProperty('webkitSpeechRecognition') || 
                            js.context.hasProperty('SpeechRecognition');
    } catch (e) {
      _isWebSpeechSupported = false;
    }
  }

  // 음성 인식 시작 
  void _startRecording() async {
    if (!_isWebSpeechSupported) {
      _showErrorMessage('이 브라우저는 음성 인식을 지원하지 않습니다.');
      return;
    }

    setState(() {
      _state = RecordingState.recording;
      _transcribedText = '';
      _processedRecord = null;
      _recordingDuration = Duration.zero;
    });

    try {
      // Web Speech API 사용 (수정된 부분)
      _speechRecognition = html.SpeechRecognition();
      _speechRecognition!.lang = 'ko-KR';
      _speechRecognition!.continuous = true;
      _speechRecognition!.interimResults = true;

      _speechRecognition!.onResult.listen((html.SpeechRecognitionEvent event) {
        String finalTranscript = '';
        String interimTranscript = '';

        // 수정된 부분: results 접근 방식 변경
        for (int i = event.resultIndex!; i < event.results!.length; i++) {
          var result = event.results![i];
          // result에서 첫 번째 대안 가져오기 (수정됨)
          String transcript = result.item(0)!.transcript!;
          
          if (result.isFinal!) {
            finalTranscript += transcript;
          } else {
            interimTranscript += transcript;
          }
        }

        setState(() {
          _transcribedText = finalTranscript + interimTranscript;
        });
      });

      _speechRecognition!.onError.listen((html.Event event) {
        _stopRecording();
        _showErrorMessage('음성 인식 중 오류가 발생했습니다.');
      });

      _speechRecognition!.start();
      
      // 애니메이션 시작
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
      
      // 녹음 시간 타이머
      _startTimer();

    } catch (e) {
      setState(() {
        _state = RecordingState.error;
      });
      _showErrorMessage('음성 인식을 시작할 수 없습니다: $e');
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_state == RecordingState.recording) {
        setState(() {
          _recordingDuration = Duration(seconds: _recordingDuration.inSeconds + 1);
        });
        _startTimer();
      }
    });
  }

  // 음성 인식 중지
  void _stopRecording() {
    _speechRecognition?.stop();
    _pulseController.stop();
    _waveController.stop();

    if (_transcribedText.trim().isEmpty) {
      setState(() {
        _state = RecordingState.ready;
      });
      _showErrorMessage('음성이 인식되지 않았습니다. 다시 시도해주세요.');
      return;
    }

    setState(() {
      _state = RecordingState.processing;
    });

    // AI 처리 시뮬레이션
    _processRecording();
  }

  // 간호기록 AI 처리 시뮬레이션
  Future<void> _processRecording() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final processed = _generateProcessedRecord(_transcribedText);
      
      setState(() {
        _processedRecord = processed;
        _state = RecordingState.completed;
      });
    } catch (e) {
      setState(() {
        _state = RecordingState.error;
      });
      _showErrorMessage('기록 처리 중 오류가 발생했습니다.');
    }
  }

  // 샘플 AI 처리 로직
  ProcessedRecord _generateProcessedRecord(String text) {
    String category = 'V/S';
    String priority = '보통';
    String? keyFindings;
    String? actionTaken;
    String? patientResponse;
    String? followUpNeeded;

    // 간단한 키워드 기반 분류
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('혈압') || lowerText.contains('체온') || lowerText.contains('맥박')) {
      category = 'V/S';
      keyFindings = '활력징후 측정 완료';
    } else if (lowerText.contains('약') || lowerText.contains('투약') || lowerText.contains('주사')) {
      category = '투약';
      actionTaken = '처방에 따른 투약 실시';
    } else if (lowerText.contains('수액') || lowerText.contains('소변') || lowerText.contains('배뇨')) {
      category = 'I/O';
      keyFindings = '수분 균형 상태 확인';
    } else if (lowerText.contains('관찰') || lowerText.contains('상태') || lowerText.contains('증상')) {
      category = '관찰';
      keyFindings = '환자 상태 변화 관찰';
    } else if (lowerText.contains('교육') || lowerText.contains('설명') || lowerText.contains('안내')) {
      category = '교육';
      actionTaken = '환자 교육 실시';
      patientResponse = '교육 내용 이해 확인됨';
    } else if (lowerText.contains('처치') || lowerText.contains('드레싱') || lowerText.contains('소독')) {
      category = '처치';
      actionTaken = '처치 시행';
    }

    // 우선순위 결정
    if (lowerText.contains('응급') || lowerText.contains('즉시') || lowerText.contains('위험')) {
      priority = '높음';
      followUpNeeded = '지속적인 모니터링 필요';
    } else if (lowerText.contains('안정') || lowerText.contains('정상') || lowerText.contains('양호')) {
      priority = '낮음';
    }

    // 환자 반응 추출
    if (lowerText.contains('환자가') || lowerText.contains('표현') || lowerText.contains('말씀')) {
      patientResponse = '환자 의견 청취 완료';
    }

    return ProcessedRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: category,
      content: text,
      priority: priority,
      timestamp: DateTime.now(),
      keyFindings: keyFindings,
      actionTaken: actionTaken,
      patientResponse: patientResponse,
      followUpNeeded: followUpNeeded,
    );
  }

  // 기록 저장
  void _saveRecord() {
    if (_processedRecord == null) return;

    // 실제로는 API나 로컬 스토리지에 저장
    // 여기서는 시뮬레이션
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_processedRecord!.category} 기록이 저장되었습니다!',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // 새로운 기록을 위해 초기화
    _resetRecording();
  }

  // 기록 초기화
  void _resetRecording() {
    setState(() {
      _state = RecordingState.ready;
      _transcribedText = '';
      _processedRecord = null;
      _recordingDuration = Duration.zero;
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Color _getCategoryColor(String category) {
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

  Color _getPriorityColor(String priority) {
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

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _speechRecognition?.stop();
    super.dispose();
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
            const Text(
              '음성 차팅',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.patientName != null)
              Text(
                '${widget.patientName} • ${widget.room}',
                style: const TextStyle(
                  color: Color(0xFF7F8C8D),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 환자 정보 (있는 경우)
            if (widget.patientName != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF4A90E2)),
                        const SizedBox(width: 8),
                        Text(
                          widget.patientName!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    if (widget.diagnosis != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '진단: ${widget.diagnosis}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 녹음 인터페이스
            _buildRecordingInterface(),

            const SizedBox(height: 32),

            // 결과 표시
            if (_state == RecordingState.processing)
              _buildProcessingIndicator()
            else if (_state == RecordingState.completed && _processedRecord != null)
              _buildProcessedResult()
            else if (_transcribedText.isNotEmpty)
              _buildTranscriptionResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingInterface() {
    return Column(
      children: [
        // 녹음 버튼
        GestureDetector(
          onTap: () {
            if (_state == RecordingState.ready) {
              _startRecording();
            } else if (_state == RecordingState.recording) {
              _stopRecording();
            }
          },
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _state == RecordingState.recording ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getRecordingButtonColor(),
                    boxShadow: [
                      BoxShadow(
                        color: _getRecordingButtonColor().withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getRecordingButtonIcon(),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // 상태 텍스트
        Text(
          _getStatusText(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // 가이드 텍스트
        Text(
          _getGuideText(),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),

        // 녹음 시간
        if (_state == RecordingState.recording) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_recordingDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],

        // 웹 음성 인식 지원 여부
        if (!_isWebSpeechSupported) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFEAA7)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: Color(0xFF856404)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '현재 브라우저에서는 음성 인식이 제한될 수 있습니다. Chrome을 권장합니다.',
                    style: TextStyle(
                      color: Color(0xFF856404),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'AI가 간호기록을 분석하고 있습니다...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '잠시만 기다려주세요',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.transcribe, color: Color(0xFF4A90E2)),
              const SizedBox(width: 8),
              const Text(
                '음성 인식 결과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _transcribedText,
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

  Widget _buildProcessedResult() {
    final record = _processedRecord!;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCategoryColor(record.category).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(record.category),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    record.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(record.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record.priority,
                    style: TextStyle(
                      color: _getPriorityColor(record.priority),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 내용
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '기록 내용',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  record.content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2C3E50),
                    height: 1.5,
                  ),
                ),

                if (record.keyFindings != null) ...[
                  const SizedBox(height: 16),
                  _buildRecordDetail('주요 발견사항', record.keyFindings!, Icons.search),
                ],

                if (record.actionTaken != null) ...[
                  const SizedBox(height: 12),
                  _buildRecordDetail('수행한 간호행위', record.actionTaken!, Icons.medical_services),
                ],

                if (record.patientResponse != null) ...[
                  const SizedBox(height: 12),
                  _buildRecordDetail('환자 반응', record.patientResponse!, Icons.record_voice_over),
                ],

                if (record.followUpNeeded != null) ...[
                  const SizedBox(height: 12),
                  _buildRecordDetail('추가 관찰 필요', record.followUpNeeded!, Icons.flag, 
                      isImportant: true),
                ],
              ],
            ),
          ),

          // 액션 버튼들
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveRecord,
                    icon: const Icon(Icons.save),
                    label: const Text('간호기록 저장하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // 간호기록지 보기
                          Navigator.pushReplacementNamed(
                            context,
                            '/nursing-record/${widget.patientId}',
                            arguments: {
                              'patientName': widget.patientName,
                              'room': widget.room,
                              'diagnosis': widget.diagnosis,
                            },
                          );
                        },
                        icon: const Icon(Icons.description),
                        label: const Text('기록지 보기'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4A90E2),
                          side: const BorderSide(color: Color(0xFF4A90E2)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetRecording,
                        icon: const Icon(Icons.refresh),
                        label: const Text('새로 녹음'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6C757D),
                          side: const BorderSide(color: Color(0xFF6C757D)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordDetail(String title, String content, IconData icon,
      {bool isImportant = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isImportant ? const Color(0xFFFFF3E0) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: isImportant ? Border.all(color: const Color(0xFFFF9800)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isImportant ? const Color(0xFFFF9800) : const Color(0xFF4A90E2),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isImportant ? const Color(0xFFFF9800) : const Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2C3E50),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRecordingButtonColor() {
    switch (_state) {
      case RecordingState.ready:
        return const Color(0xFF4A90E2);
      case RecordingState.recording:
        return const Color(0xFFE74C3C);
      case RecordingState.processing:
        return const Color(0xFF95A5A6);
      case RecordingState.completed:
        return const Color(0xFF27AE60);
      case RecordingState.error:
        return const Color(0xFFE74C3C);
    }
  }

  IconData _getRecordingButtonIcon() {
    switch (_state) {
      case RecordingState.ready:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.processing:
        return Icons.hourglass_empty;
      case RecordingState.completed:
        return Icons.check;
      case RecordingState.error:
        return Icons.error;
    }
  }

  String _getStatusText() {
    switch (_state) {
      case RecordingState.ready:
        return '음성 차팅 준비 완료';
      case RecordingState.recording:
        return '음성 녹음 중...';
      case RecordingState.processing:
        return 'AI 분석 중...';
      case RecordingState.completed:
        return '간호기록 생성 완료!';
      case RecordingState.error:
        return '오류 발생';
    }
  }

  String _getGuideText() {
    switch (_state) {
      case RecordingState.ready:
        return '버튼을 눌러 간호기록을 음성으로 입력하세요';
      case RecordingState.recording:
        return '명확하게 말씀해 주세요. 완료되면 다시 버튼을 누르세요';
      case RecordingState.processing:
        return 'AI가 음성을 분석하여 구조화된 간호기록을 생성하고 있습니다';
      case RecordingState.completed:
        return '생성된 기록을 확인하고 저장하세요';
      case RecordingState.error:
        return '문제가 발생했습니다. 다시 시도해 주세요';
    }
  }
}