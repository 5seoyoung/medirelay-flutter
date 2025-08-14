import '../models/chat_message_model.dart';

abstract class ChatRepository {
  Future<String> generateAIResponse(String question, List<Map<String, dynamic>> records, Map<String, dynamic> patientInfo);
  Future<List<ChatMessageModel>> getChatHistory(String patientId);
  Future<void> saveChatHistory(String patientId, List<ChatMessageModel> messages);
  Future<void> clearChatHistory(String patientId);
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<String> generateAIResponse(String question, List<Map<String, dynamic>> records, Map<String, dynamic> patientInfo) async {
    // TODO: 실제 OpenAI API 호출
    // 지금은 샘플 응답 반환
    await Future.delayed(const Duration(seconds: 2));
    return _generateSampleResponse(question, records, patientInfo);
  }

  String _generateSampleResponse(String question, List<Map<String, dynamic>> records, Map<String, dynamic> patientInfo) {
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('체온') || lowerQuestion.contains('열')) {
      final tempRecord = records.where((r) => r['category'] == 'V/S').firstOrNull;
      if (tempRecord != null) {
        return '최근 측정한 체온은 36.5℃로 정상 범위입니다. ${_formatRecordTime(tempRecord['timestamp'])}에 측정한 기록이 있습니다.';
      }
      return '체온 관련 기록을 찾을 수 없습니다.';
    } 
    
    else if (lowerQuestion.contains('투약') || lowerQuestion.contains('약')) {
      final medicationRecord = records.where((r) => r['category'] == '투약').firstOrNull;
      if (medicationRecord != null) {
        return '${_formatRecordTime(medicationRecord['timestamp'])}에 투약 기록이 있습니다: ${medicationRecord['content']}';
      }
      return '투약 관련 기록을 찾을 수 없습니다.';
    }
    
    else if (lowerQuestion.contains('혈압')) {
      final bpRecord = records.where((r) => r['category'] == 'V/S' && r['content'].toString().contains('혈압')).firstOrNull;
      if (bpRecord != null) {
        return '최근 측정한 혈압 정보입니다: ${bpRecord['content']}';
      }
      return '혈압 관련 기록을 찾을 수 없습니다.';
    }
    
    else if (lowerQuestion.contains('수면') || lowerQuestion.contains('잠')) {
      final sleepRecord = records.where((r) => r['content'].toString().toLowerCase().contains('수면')).firstOrNull;
      if (sleepRecord != null) {
        return '수면 관련 기록: ${sleepRecord['content']}';
      }
      return '수면 관련 기록을 찾을 수 없습니다.';
    }
    
    else if (lowerQuestion.contains('상태') || lowerQuestion.contains('어떤')) {
      if (records.isNotEmpty) {
        final recentRecords = records.take(3).map((r) => '• ${r['category']}: ${r['content']}').join('\n');
        return '${patientInfo['name']} 환자의 최근 상태입니다:\n\n$recentRecords\n\n전반적으로 안정적인 상태를 유지하고 있습니다.';
      }
      return '현재 기록된 상태 정보가 없습니다.';
    }
    
    else {
      return '${patientInfo['name']} 환자에 대한 구체적인 정보는 간호기록을 확인해 주세요. "체온", "투약", "혈압", "수면 상태" 등의 구체적인 질문을 해주시면 도움을 드릴 수 있습니다.';
    }
  }

  String _formatRecordTime(dynamic timestamp) {
    if (timestamp is DateTime) {
      final now = DateTime.now();
      final diff = now.difference(timestamp);
      
      if (diff.inHours < 1) {
        return '${diff.inMinutes}분 전';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}시간 전';
      } else {
        return '${diff.inDays}일 전';
      }
    }
    return '기록 시간';
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory(String patientId) async {
    // TODO: SharedPreferences에서 채팅 기록 로드
    return [];
  }

  @override
  Future<void> saveChatHistory(String patientId, List<ChatMessageModel> messages) async {
    // TODO: SharedPreferences에 채팅 기록 저장
  }

  @override
  Future<void> clearChatHistory(String patientId) async {
    // TODO: SharedPreferences에서 채팅 기록 삭제
  }
}