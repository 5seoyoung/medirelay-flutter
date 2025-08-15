import 'package:flutter/material.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/usecases/chat_usecases.dart';

class ChatController extends ChangeNotifier {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SaveChatHistoryUseCase saveChatHistoryUseCase;
  final ClearChatHistoryUseCase clearChatHistoryUseCase;

  ChatController({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.saveChatHistoryUseCase,
    required this.clearChatHistoryUseCase,
  });

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChatHistory(String patientId) async {
    try {
      _messages = await getChatHistoryUseCase(patientId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> sendMessage(String content, List<Map<String, dynamic>> records, Map<String, dynamic> patientInfo, String patientId) async {
    if (content.trim().isEmpty || _isLoading) return;

    // 사용자 메시지 추가
    final userMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // AI 응답 생성
      final aiResponse = await sendMessageUseCase(content, records, patientInfo);
      
      final aiMessage = ChatMessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: MessageType.ai,
        content: aiResponse,
        timestamp: DateTime.now(),
      );

      _messages.add(aiMessage);
      
      // 채팅 기록 저장
      await saveChatHistoryUseCase(patientId, _messages);
      
    } catch (e) {
      final errorMessage = ChatMessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: MessageType.ai,
        content: '죄송합니다. 오류가 발생했습니다: $e',
        timestamp: DateTime.now(),
        isError: true,
      );
      
      _messages.add(errorMessage);
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearMessages(String patientId) async {
    try {
      await clearChatHistoryUseCase(patientId);
      _messages.clear();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}