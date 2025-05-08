import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/event.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/widgets/sample.dart';

class EventService {
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
    await Service.delete(collectionName: 'users', docId: id);
  }

  //Stream builder for reuseable widget
  eventStreamBuilder(BuildContext context) {
    return Service.streamBuilder<Event>(
      collectionName: 'events',
      fromMap: (data, docId) => Event.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];

            // Schedule notification
            // NotificationService.scheduleNotification(
            //   id: item.id.hashCode,
            //   title: item.title,
            //   body: '${item.description}',
            //   scheduledDate: item.date,
            // );

            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                '${Global.dateTimeFormat(item.date.toLocal())}\n ${item.description ?? ''}',
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

    showDialog(
      context: context,
      builder: (context) {
        DateTime tempSelectedDate = selectedDate;

        return StatefulBuilder(
          builder: (context, setState) {
            // Function to pick date and time
            Future<void> pickDateTime() async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: tempSelectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && context.mounted) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(tempSelectedDate),
                );

                if (pickedTime != null) {
                  final DateTime combined = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  setState(() {
                    tempSelectedDate = combined;
                  });
                }
              }
            }

            // AlertDialog to show the form
            return AlertDialog(
              title: Text(
                item == null ? 'Add Event' : 'Edit Event',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 10),

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
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text('Datetime'),
                    subtitle: Text(Global.dateTimeFormat(tempSelectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: pickDateTime,
                  ),
                ],
              ),
              actions: [
                Button(
                  click: () => Navigator.of(context).pop(),
                  label: 'Cancel',
                  icon: Icons.cancel,
                  color: Colors.black,
                ),
                Button(
                  click: () {
                    // Save the event
                    if (item == null) {
                      if (title.text.isNotEmpty) {
                        final event = Event(
                          title: title.text,
                          date: tempSelectedDate,
                          description: description.text,
                          id: '',
                        );
                        store(event);

                        // Schedule the notification
                        // NotificationService.scheduleNotification(
                        //   id: event.title.hashCode,
                        //   title: event.title,
                        //   body: event.description ?? '',
                        //   scheduledDate: event.date,
                        // );

                        title.clear();
                        description.clear();
                        setState(() {
                          selectedDate = tempSelectedDate;
                        });

                        Navigator.pop(context);
                        Global.message(
                          context,
                          message: 'Created successfully!',
                        );
                      } else {
                        Global.message(
                          context,
                          message: 'Please enter an event title.',
                          bgColor: Colors.red,
                        );
                      }
                    } else {
                      // Update existing event
                      if (title.text.isNotEmpty) {
                        update(
                          Event(
                            id: item.id, // assuming Event has an id field
                            title: title.text,
                            date: tempSelectedDate,
                            description: description.text,
                          ),
                        );

                        title.clear();
                        description.clear();
                        setState(() {
                          selectedDate = tempSelectedDate;
                        });

                        Navigator.pop(context);
                        Global.message(
                          context,
                          message: 'Udpated successfully!',
                          bgColor: Colors.green,
                        );
                      } else {
                        Global.message(
                          context,
                          message: 'Please enter an event title.',
                          bgColor: Colors.red,
                        );
                      }
                    }
                  },
                  color: item == null ? Colors.blueAccent : Colors.green,
                  label: item == null ? 'Save' : 'Update',
                  icon: item == null ? Icons.save : Icons.update,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class MeetingService {
  final _collection = FirebaseFirestore.instance.collection('meetings');

  Future<List<Meeting>> getMeetings() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => Meeting.fromMap(doc)).toList();
  }

  Future<void> addMeeting(Meeting meeting) async {
    await _collection.add(meeting.toMap());
  }

  Future<void> updateMeeting(Meeting meeting) async {
    if (meeting.id != null) {
      await _collection.doc(meeting.id).update(meeting.toMap());
    }
  }

  Future<void> deleteMeeting(String id) async {
    await _collection.doc(id).delete();
  }
}
