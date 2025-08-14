// lib/features/nursing_record/data/models/nursing_record_model.dart
class NursingRecordModel {
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
  final String nurseId;

  NursingRecordModel({
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
    required this.nurseId,
  });

  factory NursingRecordModel.fromJson(Map<String, dynamic> json) {
    return NursingRecordModel(
      id: json['id'],
      patientId: json['patient_id'],
      category: json['category'],
      content: json['content'],
      priority: json['priority'],
      timestamp: DateTime.parse(json['timestamp']),
      keyFindings: json['key_findings'],
      actionTaken: json['action_taken'],
      patientResponse: json['patient_response'],
      followUpNeeded: json['follow_up_needed'],
      nurseName: json['nurse_name'],
      nurseId: json['nurse_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'category': category,
      'content': content,
      'priority': priority,
      'timestamp': timestamp.toIso8601String(),
      'key_findings': keyFindings,
      'action_taken': actionTaken,
      'patient_response': patientResponse,
      'follow_up_needed': followUpNeeded,
      'nurse_name': nurseName,
      'nurse_id': nurseId,
    };
  }
}

// lib/features/nursing_record/data/repositories/nursing_record_repository.dart
import '../models/nursing_record_model.dart';

abstract class NursingRecordRepository {
  Future<List<NursingRecordModel>> getNursingRecords(String patientId);
  Future<List<NursingRecordModel>> getNursingRecordsByCategory(String patientId, String category);
  Future<NursingRecordModel> createNursingRecord(NursingRecordModel record);
  Future<NursingRecordModel> updateNursingRecord(NursingRecordModel record);
  Future<void> deleteNursingRecord(String recordId);
}

class NursingRecordRepositoryImpl implements NursingRecordRepository {
  // TODO: API 클라이언트 주입
  
  @override
  Future<List<NursingRecordModel>> getNursingRecords(String patientId) async {
    // TODO: API 호출 구현
    throw UnimplementedError();
  }

  @override
  Future<List<NursingRecordModel>> getNursingRecordsByCategory(String patientId, String category) async {
    // TODO: API 호출 구현
    throw UnimplementedError();
  }

  @override
  Future<NursingRecordModel> createNursingRecord(NursingRecordModel record) async {
    // TODO: API 호출 구현
    throw UnimplementedError();
  }

  @override
  Future<NursingRecordModel> updateNursingRecord(NursingRecordModel record) async {
    // TODO: API 호출 구현
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNursingRecord(String recordId) async {
    // TODO: API 호출 구현
    throw UnimplementedError();
  }
}

// lib/features/nursing_record/domain/usecases/get_nursing_records_usecase.dart
import '../../../nursing_record/data/models/nursing_record_model.dart';
import '../../../nursing_record/data/repositories/nursing_record_repository.dart';

class GetNursingRecordsUseCase {
  final NursingRecordRepository repository;

  GetNursingRecordsUseCase(this.repository);

  Future<List<NursingRecordModel>> call(String patientId, {String? category}) async {
    if (category != null && category != 'all') {
      return await repository.getNursingRecordsByCategory(patientId, category);
    }
    return await repository.getNursingRecords(patientId);
  }
}

// lib/features/nursing_record/presentation/controllers/nursing_record_controller.dart
import 'package:flutter/material.dart';
import '../../data/models/nursing_record_model.dart';
import '../../domain/usecases/get_nursing_records_usecase.dart';

class NursingRecordController extends ChangeNotifier {
  final GetNursingRecordsUseCase getNursingRecordsUseCase;

  NursingRecordController(this.getNursingRecordsUseCase);

  List<NursingRecordModel> _records = [];
  String _selectedCategory = 'all';
  bool _isLoading = false;
  String? _error;

  List<NursingRecordModel> get records => _records;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<NursingRecordModel> get filteredRecords {
    if (_selectedCategory == 'all') {
      return _records;
    }
    return _records.where((record) => record.category == _selectedCategory).toList();
  }

  Future<void> loadNursingRecords(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _records = await getNursingRecordsUseCase(patientId, category: _selectedCategory);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _records = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void refresh(String patientId) {
    loadNursingRecords(patientId);
  }
}