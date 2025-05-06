import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smple_app/core/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new event
  Future<void> addEvent(Event event) async {
    await _firestore.collection('events').add(event.toFirestore());
  }

  // Get a stream of all events
  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Update an existing event
  Future<void> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id).update(event.toFirestore());
  }

  // Delete an event by its ID
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }
}