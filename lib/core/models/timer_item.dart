import 'dart:async';

class TimerItem {
  final String id;
  final String title;
  final int duration; // in seconds
  final DateTime startTime;

  TimerItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory TimerItem.fromMap(Map<String, dynamic> map) {
    return TimerItem(
      id: map['id'],
      title: map['title'],
      duration: map['duration'],
      startTime: DateTime.parse(map['startTime']),
    );
  }

  Duration get timeLeft {
    final endTime = startTime.add(Duration(seconds: duration));
    return endTime.difference(DateTime.now());
  }

  bool get isExpired => timeLeft.isNegative;
}

class TimerData {
  String id;
  String title;
  int totalTime;
  int remainingTime;
  bool isPaused;
  Timer? countdown;

  TimerData({
    required this.id,
    required this.title,
    required this.totalTime,
    required this.remainingTime,
    this.isPaused = false,
    this.countdown,
  });
}
