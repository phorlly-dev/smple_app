import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/event.dart';
import 'package:smple_app/core/services/notification_service.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/widgets/sample.dart';

class EventService {
  final notification = NotificationService();

  // Add a new event
  Future<void> store(Event object) async {
    await Service.create<Event>(
      model: object,
      collectionName: 'events',
      toMap: (event) => event.toMap(),
    );
  }

  // Update an existing data
  Future<void> update(Event object) async {
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
  liveStream(BuildContext context) {
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
                '${Global.dateTimeFormat(item.date)}\n ${item.description ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: ActionButtons(
                pressedOnDelete: () {
                  Global.confirmDelete(
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
                  showForm(context, item);
                },
              ),
            );
          },
        );
      },
    );
  }

  // Function to show the form dialog for adding/editing a user
  void showForm(BuildContext context, Event? item) {
    final title = TextEditingController(text: item?.title ?? '');
    final description = TextEditingController(text: item?.description ?? '');
    DateTime selectedDate = item?.date ?? DateTime.now();

    // Show the dialog
    Global.showModal(
      context: context,
      builder: (context, setState) {
        return Global.form(
          model: item,
          context,
          title: 'Event',
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            Global.showDateTimePicker(
              context,
              label: 'Datetime',
              selected: selectedDate,
              changed: (value) => setState(() => selectedDate = value),
            ),
            TextField(
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
                helperMaxLines: 5,
              ),
            ),
          ],

          // Save button
          onSave: () async {
            if (title.text.isEmpty) {
              Global.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              final event = Event(
                title: title.text,
                date: selectedDate,
                description: description.text,
                id: '',
              );
              await store(event);

              // Schedule the notification
              // NotificationService.scheduleNotification(
              //   id: event.title.hashCode,
              //   title: event.title,
              //   body: event.description ?? '',
              //   scheduledDate: event.date,
              // );

              title.clear();
              description.clear();

              if (context.mounted) {
                Navigator.pop(context);
                Global.message(context, message: 'Created successfully!');
              }
            }
          },

          // Update button
          onUpdate: () async {
            if (title.text.isEmpty) {
              Global.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              await update(
                Event(
                  id: item!.id, // assuming Event has an id field
                  title: title.text,
                  date: selectedDate,
                  description: description.text,
                ),
              );

              if (context.mounted) {
                Navigator.pop(context);
                Global.message(
                  context,
                  message: 'Updated successfully!',
                  bgColor: Colors.green,
                );
              }
            }
          },
        );
      },
    );
  }
}
