import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/common/meeting_data_source.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/event_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  final _service = MeetingService();
  List<Meeting> meetings = [];

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    final fetched = await _service.getMeetings();
    setState(() => meetings = fetched);
  }

  void _showMeetingDialog({Meeting? existing}) {
    final titleController = TextEditingController(text: existing?.eventName);
    DateTime start = existing?.from ?? DateTime.now();
    DateTime end = existing?.to ?? DateTime.now().add(const Duration(hours: 1));
    bool isAllDay = existing?.isAllDay ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                existing == null ? 'Add Meeting' : 'Edit Meeting',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  ListTile(
                    title: Text('From'),
                    subtitle: Text(Global.dateTimeFormat(start)),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: start,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(start),
                        );
                        if (time != null) {
                          setState(() {
                            start = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  ListTile(
                    title: Text('To'),
                    subtitle: Text(Global.dateTimeFormat(end)),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: end,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(end),
                        );
                        if (time != null) {
                          setState(() {
                            end = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  CheckboxListTile(
                    value: isAllDay,
                    onChanged:
                        (value) => setState(() => isAllDay = value ?? false),
                    title: const Text('All Day'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),

                if (existing != null)
                  TextButton(
                    onPressed: () async {
                      await _service.deleteMeeting(existing.id!);

                      if (context.mounted) {
                        Navigator.pop(context);
                        _loadMeetings();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meeting deleted')),
                        );
                      }
                    },
                    child: const Text('Delete'),
                  ),

                TextButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Title cannot be empty')),
                      );
                    } else {
                      final meeting = Meeting(
                        id: existing?.id,
                        eventName: titleController.text,
                        from: start,
                        to: end,
                        background: Colors.green,
                        isAllDay: isAllDay,
                      );

                      existing == null
                          ? await _service.addMeeting(meeting)
                          : await _service.updateMeeting(meeting);

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meeting saved')),
                        );
                        _loadMeetings();
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Calendar')),
      body: SfCalendar(
        view: CalendarView.month,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
        ],
        dataSource: MeetingDataSource(meetings),
        monthViewSettings: MonthViewSettings(showAgenda: true),
        onTap: (details) {
          if (details.appointments != null &&
              details.appointments!.isNotEmpty) {
            final meeting = details.appointments!.first as Meeting;
            _showMeetingDialog(existing: meeting);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMeetingDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
