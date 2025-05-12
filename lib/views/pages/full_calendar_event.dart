import 'package:flutter/material.dart';
import 'package:smple_app/common/general.dart';
import 'package:smple_app/core/services/meeting_service.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  final _service = MeetingService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Full Calendar',
        content: _service.liveStream(context),
        button: FloatingActionButton(
          onPressed: () => _service.showForm(context, model: null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
