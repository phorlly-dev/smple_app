import 'package:flutter/material.dart';
import 'package:smple_app/core/dialogs/index.dart';
import 'package:smple_app/core/functions/index.dart';
import 'package:smple_app/core/models/event.dart';
import 'package:smple_app/core/services/notification_service.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/forms/even_form.dart';
import 'package:smple_app/views/widgets/generals/sample.dart';

class EventService {
  final notification = NotificationService();

  // Add a new event
  static Future<void> store(Event object) async {
    await Service.create<Event>(
      model: object,
      collectionName: 'events',
      toMap: (event) => event.toMap(),
    );
  }

  // Update an existing data
  static Future<void> update(Event object) async {
    // Update the data in Firestore
    await Service.update(
      collectionName: 'events',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Get all events
  Future<List<Event>> index() async {
    // Get all events from Firestore
    final snapshot = await Service.readAll<Event>(
      collectionName: 'events',
      fromMap: (data, docId) => Event.fromMap(data, docId),
    );

    return snapshot;
  }

  // Delete an User by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'events', docId: id);
  }

  //Stream builder for reuseable widget
  stream(BuildContext context) {
    return Service.streamBuilder<Event>(
      collectionName: 'events',
      fromMap: (data, docId) => Event.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                '${Funcs.dateTimeFormat(item.date)}\n ${item.description ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: ActionButtons(
                pressedOnDelete: () {
                  Popup.confirmDelete(
                    context,
                    message: item.title,
                    confirmed: () {
                      Navigator.of(context).pop();
                      remove(item.id);

                      // Optionally refresh the UI or show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted successfully')),
                      );
                    },
                  );
                },
                pressedOnEdit: () {
                  EvenForm.showForm(context, item);
                },
              ),
            );
          },
        );
      },
    );
  }
}
