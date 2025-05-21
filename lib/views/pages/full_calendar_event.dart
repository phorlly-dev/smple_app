import 'package:flutter/material.dart';
import 'package:smple_app/core/services/meeting_service.dart';
import 'package:smple_app/views/forms/meeting_form.dart';
import 'package:smple_app/views/widgets/app/topbar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Full Calendar',
        content: MeetingService.stream(context),
        button: FloatingActionButton(
          onPressed: () => MeetingForm.showForm(context, model: null),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
