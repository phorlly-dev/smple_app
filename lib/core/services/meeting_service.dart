import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/common/meeting_data_source.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingService {
  final collection = FirebaseFirestore.instance.collection('meetings');

  Future<List<Meeting>> index() async {
    final snapshot = await collection.get();

    return snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();
  }

  // Fetch all meetings from Firestore
  // Future<List<Meeting>> index() async {
  //   final snapshot = await Service.readAll<Meeting>(
  //     collectionName: 'meetings',
  //     fromMap: (data, docId) => Meeting.fromMap(data, docId),
  //   );

  //   return snapshot;
  // }

  // Fetch a single meeting by its ID
  Future<void> store(Meeting object) async {
    await Service.create<Meeting>(
      model: object,
      collectionName: 'meetings',
      toMap: (event) => event.toMap(),
    );
  }

  // Fetch a single meeting by its ID
  Future<void> update(Meeting object) async {
    // Update the data in Firestore
    await Service.update(
      collectionName: 'meetings',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Delete a meeting by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'meetings', docId: id);
  }

  // Stream builder for reusable widget
  liveStream(BuildContext context) {
    return Service.streamBuilder<Meeting>(
      collectionName: 'meetings',
      fromMap: (data, docId) {
        log('Meeting data: $data');
        return Meeting.fromMap(data, docId);
      },
      builder: (context, data) {
        return SfCalendar(
          view: CalendarView.month,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
            CalendarView.schedule,
          ],
          dataSource: MeetingDataSource(data),
          monthViewSettings: MonthViewSettings(showAgenda: true),
          onTap: (details) {
            if (details.appointments != null &&
                details.appointments!.isNotEmpty) {
              final item = details.appointments!.first as Meeting;
              showForm(context, model: item);
            }
          },
        );
      },
    );
  }

  // Show a form to create or update a meeting
  void showForm(BuildContext context, {Meeting? model}) {
    final title = TextEditingController(text: model?.eventName);
    DateTime start = model?.from ?? DateTime.now();
    DateTime end = model?.to ?? DateTime.now().add(const Duration(hours: 1));
    bool isAllDay = model?.isAllDay ?? false;

    // Show the dialog
    Global.showModal(
      context: context,
      builder: (context, setState) {
        return Global.form(
          model: model,
          context,
          title: 'Meeting',
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            Global.showDateTimePicker(
              context,
              label: 'From',
              selected: start,
              changed: (value) => setState(() => start = value),
            ),

            Global.showDateTimePicker(
              context,
              label: 'To',
              selected: end,
              changed: (value) => setState(() => end = value),
            ),

            CheckboxListTile(
              value: isAllDay,
              onChanged: (value) => setState(() => isAllDay = value ?? false),
              title: const Text('All Day'),
            ),
          ],

          // Delete button
          onDelete: () {
            Global.confirmDelete(
              context,
              message: model!.eventName,
              confirmed: () async {
                await remove(model.id);

                if (context.mounted) {
                  Navigator.pop(context);
                  Global.message(
                    context,
                    message: 'Deleted successfully!',
                    bgColor: Colors.red,
                  );

                  Navigator.pop(context);
                }
              },
            );
          },

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
              await store(
                Meeting(
                  id: '',
                  eventName: title.text,
                  from: start,
                  to: end,
                  background: Colors.green,
                  isAllDay: isAllDay,
                ),
              );

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
                Meeting(
                  id: model!.id,
                  eventName: title.text,
                  from: start,
                  to: end,
                  background: Colors.green,
                  isAllDay: isAllDay,
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
