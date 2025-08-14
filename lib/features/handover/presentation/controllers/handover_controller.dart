import 'package:flutter/material.dart';
import '../../data/models/handover_model.dart';
import '../../domain/usecases/generate_handover_usecase.dart';

class HandoverController extends ChangeNotifier {
  final GenerateHandoverUseCase generateHandoverUseCase;
  final SaveHandoverUseCase saveHandoverUseCase;
  final GetHandoverUseCase getHandoverUseCase;

  HandoverController({
    required this.generateHandoverUseCase,
    required this.saveHandoverUseCase,
    required this.getHandoverUseCase,
  });

  HandoverModel? _currentHandover;
  bool _isGenerating = false;
  String? _error;

  HandoverModel? get currentHandover => _currentHandover;
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  Future<void> generateHandover(String patientId, String date, String shift) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final content = await generateHandoverUseCase(patientId, date, shift);
      
      _currentHandover = HandoverModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: patientId,
        date: date,
        shift: shift,
        content: content,
        createdAt: DateTime.now(),
        recordCount: 0, // TODO: 실제 기록 개수로 설정
      );
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentHandover = null;
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> saveHandover() async {
    if (_currentHandover == null) return;

    try {
      await saveHandoverUseCase(_currentHandover!);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadHandover(String patientId, String date, String shift) async {
    try {
      _currentHandover = await getHandoverUseCase(patientId, date, shift);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentHandover = null;
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}