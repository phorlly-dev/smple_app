class LapRecord {
  final String id;
  final List<String> lapTimes;
  final String totalTime;
  final DateTime createdAt;

  LapRecord({
    required this.id,
    required this.lapTimes,
    required this.totalTime,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lapTimes': lapTimes,
      'totalTime': totalTime,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
