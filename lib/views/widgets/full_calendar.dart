import 'package:flutter/material.dart';
import 'package:smple_app/common/event_data_source.dart';
import 'package:smple_app/common/global.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:smple_app/core/models/event.dart';

class FullCalendar extends StatelessWidget {
  final List<Event> events;

  const FullCalendar({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Calendar View')),
      body: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        firstDayOfWeek: 1,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
        ],
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        showDatePickerButton: true,
        onTap: (CalendarTapDetails details) {
          if (details.appointments != null &&
              details.appointments!.isNotEmpty) {
            final Event event = details.appointments!.first;

            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: Text(
                      'Event: ${event.title}',
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      event.description!.isEmpty
                          ? 'Date Time: ${Global.dateTimeFormat(event.date)}'
                          : 'Date Time: ${Global.dateTimeFormat(event.date)} \n Details: ${event.description}',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
            );
          }
        },
      ),
    );
  }
}
