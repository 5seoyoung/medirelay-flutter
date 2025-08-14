import 'package:flutter/foundation.dart'; // ChangeNotifier
import 'package:equatable/equatable.dart';

class NursingRecord extends Equatable {
  final String id;
  final String patientId;
  final DateTime createdAt;
  final String note;

  const NursingRecord({
    required this.id,
    required this.patientId,
    required this.createdAt,
    required this.note,
  });

  NursingRecord copyWith({
    String? id,
    String? patientId,
    DateTime? createdAt,
    String? note,
  }) {
    return NursingRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, patientId, createdAt, note];
}

/// 간단 컨트롤러 (notifyListeners 사용 위치 보완)
class NursingRecordController extends ChangeNotifier {
  final List<NursingRecord> _records = [];

  List<NursingRecord> get records => List.unmodifiable(_records);

  void setRecords(List<NursingRecord> items) {
    _records
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void addRecord(NursingRecord record) {
    _records.add(record);
    notifyListeners();
  }

  void updateRecord(String id, NursingRecord Function(NursingRecord) updater) {
    final idx = _records.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _records[idx] = updater(_records[idx]);
      notifyListeners();
    }
  }

  void removeRecord(String id) {
    _records.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}