import 'package:flutter/material.dart';
import 'package:smple_app/common/nav_link.dart';
import 'package:smple_app/core/services/event_service.dart';
import 'package:smple_app/views/widgets/full_calendar.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({super.key});

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  final _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Simple Calendar',
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: _eventService.liveStream(context)),
            ],
          ),
        ),

        button: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'add_event',
              onPressed: () => _eventService.showForm(context, null),
              tooltip: 'Add Event',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'view_calendar',
              onPressed: () async {
                final events = await _eventService.index();
                if (context.mounted) {
                  NavLink.next(context, widget: FullCalendar(events: events));
                }
              },
              tooltip: 'View Calendar',
              child: const Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }
}
