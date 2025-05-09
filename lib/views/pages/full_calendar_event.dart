import 'package:flutter/material.dart';
import 'package:smple_app/common/meeting_data_source.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/meeting_service.dart';
import 'package:smple_app/views/widgets/topbar.dart';
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
    loadData();
  }

  Future<void> loadData() async {
    final fetched = await _service.index();
    setState(() => meetings = fetched);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Full Calendar',
        content: SfCalendar(
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
              _service.showForm(context, model: meeting, refresh: loadData);
            }
          },
        ),
        button: FloatingActionButton(
          onPressed: () => _service.showForm(context, model: null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
