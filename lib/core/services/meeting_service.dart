import 'package:flutter/material.dart';
import 'package:smple_app/common/meeting_data_source.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/notification_service.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/forms/meeting_form.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingService {
  static final notification = NotificationService();

  // Fetch all meetings from Firestore
  // Future<List<Meeting>> index() async {
  //   final snapshot = await Service.readAll<Meeting>(
  //     collectionName: 'meetings',
  //     fromMap: (data, docId) => Meeting.fromMap(data, docId),
  //   );

  //   return snapshot;
  // }

  // Fetch a single meeting by its ID
  static Future<void> store(Meeting object) async {
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
  static Future<void> update(Meeting object) async {
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
  static Future<void> remove(String id) async {
    await Service.delete(collectionName: 'meetings', docId: id);

    // Cancel notification when a meeting is deleted
    await notification.cancelNotification(id);
  }

  // Stream builder for reusable widget
  static stream(BuildContext context) {
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
              MeetingForm.showForm(context, model: item);
            }
          },
        );
      },
    );
  }
}
