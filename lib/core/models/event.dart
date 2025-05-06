import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  DateTime date;

  Event({required this.id, required this.title, required this.date});

  // Add a factory constructor to create an Event from a Firestore document
  factory Event.fromFirestore(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Add a method to convert an Event to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': date,
    };
  }
}