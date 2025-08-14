import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../widgets/recording_button.dart';
import '../widgets/voice_visualizer.dart';

/// 음성 차팅 페이지
/// React 버전의 Record.jsx를 Flutter로 완전 구현
class VoiceRecordingPage extends StatefulWidget {
  const VoiceRecordingPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.room,
    required this.diagnosis,
  });

  final String patientId;
  final String patientName;
  final String room;
  final String diagnosis;

  @override
  State<VoiceRecordingPage> createState() => _VoiceRecordingPageState();
}

class _VoiceRecordingPageState extends State<VoiceRecordingPage> 
    with TickerProviderStateMixin {
  
  // React의 useState와 동일한 상태들
  RecordingStep _currentStep = RecordingStep.ready;
  bool _isRecording = false;
  bool _isProcessing = false;
  int _recordingTime = 0;
  String _transcribedText = '';
  ClassifiedRecord? _classifiedRecord;
  String _errorMessage = '';
  
  // 애니메이션 컨트롤러들
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  
  // 타이머
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPatientInfoCard(),
                        const SizedBox(height: 24),
                        _buildRecordingStatusCard(),
                        const SizedBox(height: 32),
                        _buildMainContent(),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildErrorCard(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 헤더 (React의 header와 동일)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          CustomButton(
            text: '← 뒤로',
            onPressed: () => Navigator.of(context).pop(),
            type: CustomButtonType.text,
            size: CustomButtonSize.small,
          ),
          const Spacer(),
          Text(
            '음성 차팅',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 60), // 균형을 위한 빈 공간
        ],
      ),
    );
  }

  // ✅ 환자 정보 카드 (React의 patient info와 동일)
  Widget _buildPatientInfoCard() {
    return Container(
      decoration: AppDecorations.cardDefault,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.patientName,
                style: AppTextStyles.patientName,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppDecorations.radiusSmall,
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Text(
                  widget.room,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
            Text(
                '진단명',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.diagnosis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ 녹음 상태 카드 (React의 record-status와 동일)
  Widget _buildRecordingStatusCard() {
    return Container(
      decoration: AppDecorations.cardDefault.copyWith(
        color: _getStatusCardColor(),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            _getStatusText(),
            style: AppTextStyles.h4.copyWith(
              color: _getStatusTextColor(),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusSubtext(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: _getStatusTextColor().withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (_currentStep == RecordingStep.processing) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }

  // ✅ 메인 콘텐츠 (단계별 다른 UI)
  Widget _buildMainContent() {
    switch (_currentStep) {
      case RecordingStep.ready:
      case RecordingStep.classified:
        return _buildReadyContent();
      case RecordingStep.recording:
        return _buildRecordingContent();
      case RecordingStep.processing:
        return _buildProcessingContent();
      case RecordingStep.transcribed:
        return _buildTranscribedContent();
    }
  }

  // ✅ 준비 상태 콘텐츠
  Widget _buildReadyContent() {
    return Column(
      children: [
        const SizedBox(height: 32),
        RecordingButton(
          isRecording: false,
          onPressed: _handleStartRecording,
          size: 120,
        ),
        const SizedBox(height: 24),
        Text(
          '버튼을 눌러 음성 기록을 시작하세요',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (_currentStep == RecordingStep.classified) ...[
          const SizedBox(height: 32),
          _buildClassifiedRecordCard(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ],
    );
  }

  // ✅ 녹음 중 콘텐츠
  Widget _buildRecordingContent() {
    return Column(
      children: [
        const SizedBox(height: 32),
        RecordingButton(
          isRecording: true,
          onPressed: _handleStopRecording,
          size: 120,
        ),
        const SizedBox(height: 24),
        VoiceVisualizer(isRecording: _isRecording),
        const SizedBox(height: 24),
        Text(
          _formatTime(_recordingTime),
          style: AppTextStyles.h2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: '취소',
          onPressed: _handleCancelRecording,
          type: CustomButtonType.secondary,
          size: CustomButtonSize.medium,
          width: double.infinity,
        ),
      ],
    );
  }

  // ✅ 처리 중 콘텐츠
  Widget _buildProcessingContent() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '음성을 분석하고 있습니다...',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ 전사 완료 콘텐츠
  Widget _buildTranscribedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '변환된 텍스트:',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: _transcribedText),
          onChanged: (value) => setState(() => _transcribedText = value),
          maxLines: 6,
          decoration: AppDecorations.inputDefault(
            hintText: '음성으로 변환된 텍스트가 여기에 표시됩니다...',
          ),
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: '🤖 AI 분류 및 구조화',
                onPressed: _handleClassifyRecord,
                type: CustomButtonType.primary,
                size: CustomButtonSize.medium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: '다시 녹음하기',
                onPressed: _handleReset,
                type: CustomButtonType.secondary,
                size: CustomButtonSize.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ 분류된 기록 카드
  Widget _buildClassifiedRecordCard() {
    if (_classifiedRecord == null) return Container();

    return Container(
      decoration: AppDecorations.cardDefault,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 간호기록 분류 결과',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildClassificationRow('분류', _classifiedRecord!.category),
          const SizedBox(height: 12),
          _buildClassificationRow('우선순위', _classifiedRecord!.priority),
          const SizedBox(height: 12),
          _buildClassificationRow('주요 소견', _classifiedRecord!.keyFindings.join(', ')),
          if (_classifiedRecord!.actionTaken != null) ...[
            const SizedBox(height: 12),
            _buildClassificationRow('시행한 조치', _classifiedRecord!.actionTaken!),
          ],
          if (_classifiedRecord!.followUpNeeded != null) ...[
            const SizedBox(height: 12),
            _buildClassificationRow('추후 관찰사항', _classifiedRecord!.followUpNeeded!),
          ],
        ],
      ),
    );
  }

  Widget _buildClassificationRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 액션 버튼들
  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: '💾 기록 저장하기',
          onPressed: _handleSaveRecord,
          type: CustomButtonType.primary,
          size: CustomButtonSize.large,
          width: double.infinity,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: '🎙️ 새로 녹음하기',
          onPressed: _handleReset,
          type: CustomButtonType.secondary,
          size: CustomButtonSize.medium,
          width: double.infinity,
        ),
      ],
    );
  }

  // ✅ 에러 카드
  Widget _buildErrorCard() {
    return Container(
      decoration: AppDecorations.errorContainer,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오류 발생',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _errorMessage,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 이벤트 핸들러들 (React의 함수들과 동일)
  Future<void> _handleStartRecording() async {
    setState(() {
      _currentStep = RecordingStep.recording;
      _isRecording = true;
      _recordingTime = 0;
      _errorMessage = '';
    });

    // 타이머 시작
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordingTime++);
    });

    // 펄스 애니메이션 시작
    _pulseController.repeat(reverse: true);

    // TODO: 실제 녹음 시작 로직
  }

  void _handleStopRecording() {
    setState(() {
      _currentStep = RecordingStep.processing;
      _isRecording = false;
    });

    _recordingTimer?.cancel();
    _pulseController.stop();

    // TODO: 실제 녹음 중지 및 처리 로직
    _simulateAudioProcessing();
  }

  void _handleCancelRecording() {
    _recordingTimer?.cancel();
    _pulseController.stop();
    _handleReset();
  }

  Future<void> _handleClassifyRecord() async {
    setState(() => _isProcessing = true);

    try {
      // TODO: 실제 AI 분류 API 호출
      await _simulateClassification();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _handleSaveRecord() {
    // TODO: 실제 저장 로직
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 간호기록이 저장되었습니다!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
    _handleReset();
  }

  void _handleReset() {
    setState(() {
      _currentStep = RecordingStep.ready;
      _isRecording = false;
      _isProcessing = false;
      _recordingTime = 0;
      _transcribedText = '';
      _classifiedRecord = null;
      _errorMessage = '';
    });

    _recordingTimer?.cancel();
    _pulseController.stop();
  }

  // ✅ 시뮬레이션 함수들 (개발용)
  Future<void> _simulateAudioProcessing() async {
    await Future.delayed(const Duration(seconds: 2));

    final mockTranscriptions = [
      "환자 혈압이 130에 85이고 체온은 37도 2입니다. 통증 점수는 6점 정도로 호소하고 있어서 진통제 투여했습니다.",
      "헤모백 드레인에서 50시시 정도 배액이 나왔고 색깔은 연분홍색입니다. 상처 부위는 깨끗하고 건조합니다.",
      "환자가 식사를 절반 정도 드셨고 오심은 없다고 합니다. 수분 섭취는 충분히 하고 계십니다.",
      "활력징후 안정적이고 산소포화도 98퍼센트입니다. 호흡곤란이나 흉통 호소 없으시고 안정적입니다."
    ];

    setState(() {
      _transcribedText = mockTranscriptions[DateTime.now().millisecond % 4];
      _currentStep = RecordingStep.transcribed;
    });
  }

  Future<void> _simulateClassification() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _classifiedRecord = ClassifiedRecord(
        category: 'V/S',
        priority: '보통',
        keyFindings: ['혈압 130/85', '체온 37.2°C', '통증 6점'],
        actionTaken: '진통제 투여',
        patientResponse: '통증 감소 호소',
        followUpNeeded: '2시간 후 통증 재평가',
      );
      _currentStep = RecordingStep.classified;
    });
  }

  // ✅ 헬퍼 함수들
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getStatusCardColor() {
    switch (_currentStep) {
      case RecordingStep.ready:
        return AppColors.surface;
      case RecordingStep.recording:
        return AppColors.primary.withOpacity(0.1);
      case RecordingStep.processing:
        return AppColors.warning.withOpacity(0.1);
      case RecordingStep.transcribed:
        return AppColors.info.withOpacity(0.1);
      case RecordingStep.classified:
        return AppColors.success.withOpacity(0.1);
    }
  }

  Color _getStatusTextColor() {
    switch (_currentStep) {
      case RecordingStep.ready:
        return AppColors.textPrimary;
      case RecordingStep.recording:
        return AppColors.primary;
      case RecordingStep.processing:
        return AppColors.warning;
      case RecordingStep.transcribed:
        return AppColors.info;
      case RecordingStep.classified:
        return AppColors.success;
    }
  }

  String _getStatusText() {
    switch (_currentStep) {
      case RecordingStep.ready:
        return '음성 노트 준비';
      case RecordingStep.recording:
        return '🎙️ 녹음 중...';
      case RecordingStep.processing:
        return '🤖 처리 중...';
      case RecordingStep.transcribed:
        return '📝 음성 변환 완료';
      case RecordingStep.classified:
        return '✅ 간호기록 완료';
    }
  }

  String _getStatusSubtext() {
    switch (_currentStep) {
      case RecordingStep.ready:
        return '버튼을 눌러 음성 기록을 시작하세요';
      case RecordingStep.recording:
        return '${_formatTime(_recordingTime)} | 말씀해 주세요';
      case RecordingStep.processing:
        return '음성을 분석하고 있습니다';
      case RecordingStep.transcribed:
        return '텍스트를 확인하고 수정하세요';
      case RecordingStep.classified:
        return '분류 및 구조화가 완료되었습니다';
    }
  }
}

// ✅ 녹음 단계 열거형 (React의 step state와 동일)
enum RecordingStep {
  ready,
  recording,
  processing,
  transcribed,
  classified,
}

// ✅ 분류된 기록 모델 (React의 classifiedRecord와 동일)
class ClassifiedRecord {
  final String category;
  final String priority;
  final List<String> keyFindings;
  final String? actionTaken;
  final String? patientResponse;
  final String? followUpNeeded;

  ClassifiedRecord({
    required this.category,
    required this.priority,
    required this.keyFindings,
    this.actionTaken,
    this.patientResponse,
    this.followUpNeeded,
  });
}