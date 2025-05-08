import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meeting {
  String? id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting({
    this.id,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    this.isAllDay = false,
  });

  factory Meeting.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meeting(
      id: doc.id,
      eventName: data['eventName'] ?? 'No Title',
      from: (data['from'] as Timestamp).toDate(),
      to: (data['to'] as Timestamp).toDate(),
      background: Color(data['background']),
      isAllDay: data['isAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': from,
      'to': to,
      'background': background.toARGB32(),
      'isAllDay': isAllDay,
    };
  }
}
