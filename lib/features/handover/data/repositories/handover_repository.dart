import '../models/handover_model.dart';

abstract class HandoverRepository {
  Future<HandoverModel?> getHandover(String patientId, String date, String shift);
  Future<List<HandoverModel>> getHandoversByPatient(String patientId);
  Future<HandoverModel> createHandover(HandoverModel handover);
  Future<HandoverModel> updateHandover(HandoverModel handover);
  Future<void> deleteHandover(String handoverId);
  Future<String> generateHandoverContent(String patientId, String date, String shift);
}

class HandoverRepositoryImpl implements HandoverRepository {
  // TODO: 실제 API 구현
  
  @override
  Future<HandoverModel?> getHandover(String patientId, String date, String shift) async {
    // TODO: 로컬 스토리지 또는 API에서 인계장 조회
    throw UnimplementedError();
  }

  @override
  Future<List<HandoverModel>> getHandoversByPatient(String patientId) async {
    // TODO: 환자별 인계장 목록 조회
    throw UnimplementedError();
  }

  @override
  Future<HandoverModel> createHandover(HandoverModel handover) async {
    // TODO: 인계장 생성
    throw UnimplementedError();
  }

  @override
  Future<HandoverModel> updateHandover(HandoverModel handover) async {
    // TODO: 인계장 수정
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHandover(String handoverId) async {
    // TODO: 인계장 삭제
    throw UnimplementedError();
  }

  @override
  Future<String> generateHandoverContent(String patientId, String date, String shift) async {
    // TODO: AI API 호출하여 인계장 내용 생성
    throw UnimplementedError();
  }
}