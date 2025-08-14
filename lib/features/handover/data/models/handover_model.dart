class HandoverModel {
  final String id;
  final String patientId;
  final String date;
  final String shift; // 'day', 'evening', 'night'
  final String content;
  final DateTime createdAt;
  final int recordCount;

  HandoverModel({
    required this.id,
    required this.patientId,
    required this.date,
    required this.shift,
    required this.content,
    required this.createdAt,
    required this.recordCount,
  });

  factory HandoverModel.fromJson(Map<String, dynamic> json) {
    return HandoverModel(
      id: json['id'],
      patientId: json['patient_id'],
      date: json['date'],
      shift: json['shift'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      recordCount: json['record_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'date': date,
      'shift': shift,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'record_count': recordCount,
    };
  }
}