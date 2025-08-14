import '../../data/models/handover_model.dart';
import '../../data/repositories/handover_repository.dart';

class GenerateHandoverUseCase {
  final HandoverRepository repository;

  GenerateHandoverUseCase(this.repository);

  Future<String> call(String patientId, String date, String shift) async {
    return await repository.generateHandoverContent(patientId, date, shift);
  }
}

class SaveHandoverUseCase {
  final HandoverRepository repository;

  SaveHandoverUseCase(this.repository);

  Future<HandoverModel> call(HandoverModel handover) async {
    return await repository.createHandover(handover);
  }
}

class GetHandoverUseCase {
  final HandoverRepository repository;

  GetHandoverUseCase(this.repository);

  Future<HandoverModel?> call(String patientId, String date, String shift) async {
    return await repository.getHandover(patientId, date, shift);
  }
}