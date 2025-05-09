import 'package:flutter/material.dart';
import 'package:smple_app/core/services/meeting_service.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  final _service = MeetingService();
  // List<Meeting> meetings = [];

  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  // }

  // Future<void> loadData() async {
  //   final fetched = await _service.index();
  //   setState(() => meetings = fetched);
  // }

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
