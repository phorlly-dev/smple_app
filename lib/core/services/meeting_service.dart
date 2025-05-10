import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/common/meeting_data_source.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/notification_service.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingService {
  final notification = NotificationService();

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
      toMap: (value) => value.toMap(),
    );

    // Schedule notification if alertNotification is true and alertTime is not null
    if (object.alertNotification && object.alertTime != null) {
      await notification.scheduleNotification(
        id: object.id,
        title: object.eventName,
        scheduledTime: object.alertTime!,
      );
    }
  }

  // Fetch a single meeting by its ID
  Future<void> update(Meeting object) async {
    // Update the data in Firestore
    await Service.update(
      collectionName: 'meetings',
      docId: object.id,
      toMap: object.toMap(),
    );

    // Schedule notification if alertNotification is true and alertTime is not null
    if (object.alertNotification && object.alertTime != null) {
      await notification.scheduleNotification(
        id: object.id,
        title: object.eventName,
        scheduledTime: object.alertTime!,
      );
    } else {
      // If alertNotification is false or alertTime is null, cancel any existing notification for this meeting
      await notification.cancelNotification(object.id);
    }
  }

  // Delete a meeting by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'meetings', docId: id);

    // Cancel notification when a meeting is deleted
    await notification.cancelNotification(id);
  }

  // Stream builder for reusable widget
  liveStream(BuildContext context) {
    return Service.streamBuilder<Meeting>(
      collectionName: 'meetings',
      fromMap: (data, docId) => Meeting.fromMap(data, docId),
      builder: (context, data) {
        return SfCalendar(
          view: CalendarView.month,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
            CalendarView.schedule,
          ],
          firstDayOfWeek: 1,
          showTodayButton: true,
          allowViewNavigation: true,
          // showWeekNumber: true,
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
    bool alertNotification =
        model?.alertNotification ?? false; // Get alertNotification state
    DateTime? alertTime = model?.alertTime; // Get alertTime

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
            CheckboxListTile(
              // Add checkbox for alert notification
              value: alertNotification,
              onChanged:
                  (value) => setState(() {
                    alertNotification = value ?? false;
                    if (!alertNotification) {
                      alertTime =
                          null; // Clear alertTime if alertNotification is false
                    }
                  }),
              title: const Text('Enable Notification'),
            ),
            if (alertNotification) // Show time picker only if alertNotification is true
              Global.showDateTimePicker(
                context,
                label: 'Alert Time',
                selected:
                    alertTime ??
                    DateTime.now(), // Use current time if alertTime is null
                changed: (value) => setState(() => alertTime = value),
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
                  alertNotification:
                      alertNotification, // Save alertNotification state
                  alertTime: alertTime, // Save alertTime
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
                  alertNotification:
                      alertNotification, // Save alertNotification state
                  alertTime: alertTime, // Save alertTime
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
