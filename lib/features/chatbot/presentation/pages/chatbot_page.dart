import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 메시지 타입
enum MessageType { user, ai }

// 채팅 메시지 모델
class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.isError = false,
  });
}

class ChatbotPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String room;
  final String diagnosis;

  const ChatbotPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.room,
    required this.diagnosis,
  });

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // 샘플 간호기록 데이터
  final List<Map<String, dynamic>> _nursingRecords = [
    {
      'timestamp': '2시간 전',
      'category': 'V/S',
      'content': '혈압 120/80, 맥박 72회/분, 체온 36.5℃',
      'priority': '보통',
    },
    {
      'timestamp': '4시간 전',
      'category': '투약',
      'content': '진통제 투여 완료, 환자 통증 완화됨',
      'priority': '높음',
    },
    {
      'timestamp': '6시간 전',
      'category': '관찰',
      'content': '수면 상태 양호, 식사량 보통',
      'priority': '보통',
    },
  ];

  // 빠른 질문 템플릿
  final List<String> _quickQuestions = [
    "오늘 체온이 어떻게 됐나요?",
    "최근 투약 내역을 알려주세요",
    "혈압 수치를 확인해주세요",
    "수면 상태는 어떤가요?",
    "특별히 주의할 점이 있나요?",
    "통증 정도를 알려주세요",
  ];

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 환영 메시지 표시
  void _showWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: 'welcome',
      type: MessageType.ai,
      content: '안녕하세요! ${widget.patientName} 환자에 대한 간호 AI 어시스턴트입니다.\n\n'
          '간호기록을 바탕으로 질문에 답변해드리겠습니다. 궁금한 점을 질문해보세요!',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  // 메시지 전송
  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // AI 응답 생성 (시뮬레이션)
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      final aiResponse = _generateAIResponse(content);
      
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: MessageType.ai,
        content: aiResponse,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });

      _scrollToBottom();

    } catch (error) {
      final errorMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: MessageType.ai,
        content: '죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요.',
        timestamp: DateTime.now(),
        isError: true,
      );

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    }
  }

  // AI 응답 생성 (샘플 로직)
  String _generateAIResponse(String question) {
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('체온') || lowerQuestion.contains('열')) {
      return '📊 최근 체온 기록:\n\n'
          '• 2시간 전: 36.5℃ (정상)\n'
          '• 상태: 안정적\n'
          '• 특이사항: 없음\n\n'
          '체온이 정상 범위 내에서 안정적으로 유지되고 있습니다.';
    } 
    
    else if (lowerQuestion.contains('투약') || lowerQuestion.contains('약')) {
      return '💊 최근 투약 기록:\n\n'
          '• 4시간 전: 진통제 투여\n'
          '• 효과: 통증 완화 확인됨\n'
          '• 부작용: 없음\n\n'
          '투약 후 환자의 통증이 효과적으로 완화되었습니다.';
    }
    
    else if (lowerQuestion.contains('혈압')) {
      return '❤️ 최근 혈압 기록:\n\n'
          '• 수축기: 120mmHg\n'
          '• 이완기: 80mmHg\n'
          '• 상태: 정상 범위\n'
          '• 측정시간: 2시간 전\n\n'
          '혈압이 정상 범위 내에서 안정적입니다.';
    }
    
    else if (lowerQuestion.contains('수면') || lowerQuestion.contains('잠')) {
      return '😴 수면 상태 기록:\n\n'
          '• 6시간 전: 수면 상태 양호\n'
          '• 야간 각성: 없음\n'
          '• 수면 질: 양호\n\n'
          '환자의 수면 패턴이 개선되고 있습니다.';
    }
    
    else if (lowerQuestion.contains('주의') || lowerQuestion.contains('특이')) {
      return '⚠️ 주의사항 및 특이사항:\n\n'
          '• 현재 특별한 주의사항 없음\n'
          '• 활력징후 안정적\n'
          '• 투약 반응 양호\n\n'
          '전반적으로 안정적인 상태를 유지하고 있어 특별한 주의사항은 없습니다.';
    }
    
    else if (lowerQuestion.contains('통증')) {
      return '🩹 통증 관리 현황:\n\n'
          '• 4시간 전 진통제 투여\n'
          '• 통증 완화 효과 확인\n'
          '• 현재 통증 수준: 경미\n\n'
          '진통제 투여 후 통증이 효과적으로 관리되고 있습니다.';
    }
    
    else if (lowerQuestion.contains('안녕') || lowerQuestion.contains('도움')) {
      return '안녕하세요! 👋\n\n'
          '다음과 같은 정보를 문의하실 수 있습니다:\n\n'
          '• 체온, 혈압 등 활력징후\n'
          '• 투약 내역 및 효과\n'
          '• 수면 상태\n'
          '• 통증 관리 현황\n'
          '• 주의사항 및 특이사항\n\n'
          '구체적인 질문을 해주시면 더 정확한 답변을 드릴 수 있습니다.';
    }
    
    else {
      return '🤔 죄송합니다. "${question}"에 대한 구체적인 기록을 찾을 수 없습니다.\n\n'
          '다음과 같은 방식으로 질문해보세요:\n\n'
          '• "체온이 어떻게 됐나요?"\n'
          '• "투약 내역을 알려주세요"\n'
          '• "혈압 수치를 확인해주세요"\n\n'
          '더 구체적인 질문을 해주시면 정확한 답변을 드리겠습니다.';
    }
  }

  // 스크롤을 맨 아래로
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 채팅 기록 삭제
  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채팅 기록 삭제'),
        content: const Text('모든 채팅 기록을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
              _showWelcomeMessage();
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 시간 포맷팅
  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
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
              '${widget.patientName} - AI 질의응답',
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.room} • ${_nursingRecords.length}개 기록',
              style: const TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF7F8C8D)),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // 환자 정보 간단 표시
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '진단: ${widget.diagnosis}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 채팅 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildLoadingMessage();
                  }
                  
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),

          // 입력 영역
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.type == MessageType.user;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: message.isError 
                    ? const Color(0xFFE74C3C) 
                    : const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                message.isError ? Icons.error_outline : Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? const Color(0xFF4A90E2)
                        : message.isError
                            ? const Color(0xFFFFEBEE)
                            : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser 
                          ? Colors.white
                          : message.isError
                              ? const Color(0xFFC62828)
                              : const Color(0xFF2C3E50),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF95A5A6),
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF27AE60),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'AI가 답변을 준비하고 있습니다...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE8E8E8)),
        ),
      ),
      child: Column(
        children: [
          // 빠른 질문 버튼들
          if (_messages.length > 1) // 환영 메시지 이후
            Container(
              height: 36,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickQuestions.length,
                itemBuilder: (context, index) {
                  final question = _quickQuestions[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _sendMessage(question),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          question,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // 입력 필드
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: '환자에 대해 궁금한 점을 질문해보세요...',
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC3C7),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  onPressed: _isLoading 
                      ? null 
                      : () => _sendMessage(_messageController.text),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}