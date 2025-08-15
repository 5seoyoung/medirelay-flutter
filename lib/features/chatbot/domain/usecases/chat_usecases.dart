import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<String> call(String question, List<Map<String, dynamic>> records, Map<String, dynamic> patientInfo) async {
    return await repository.generateAIResponse(question, records, patientInfo);
  }
}

class GetChatHistoryUseCase {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  Future<List<ChatMessageModel>> call(String patientId) async {
    return await repository.getChatHistory(patientId);
  }
}

class SaveChatHistoryUseCase {
  final ChatRepository repository;

  SaveChatHistoryUseCase(this.repository);

  Future<void> call(String patientId, List<ChatMessageModel> messages) async {
    await repository.saveChatHistory(patientId, messages);
  }
}

class ClearChatHistoryUseCase {
  final ChatRepository repository;

  ClearChatHistoryUseCase(this.repository);

  Future<void> call(String patientId) async {
    await repository.clearChatHistory(patientId);
  }
}