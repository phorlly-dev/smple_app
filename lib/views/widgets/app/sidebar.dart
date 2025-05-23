import 'package:flutter/material.dart';
import 'package:smple_app/core/links/nav_link.dart';
import 'package:smple_app/views/pages/calendar_note.dart';
import 'package:smple_app/views/pages/full_calendar_event.dart';
import 'package:smple_app/views/pages/music_player.dart';
import 'package:smple_app/views/pages/simple_calendar.dart';
import 'package:smple_app/views/pages/timer_stopwatch.dart';
import 'package:smple_app/views/pages/user_list.dart';
import 'package:smple_app/views/pages/weight_calculator.dart';
import 'package:smple_app/views/widgets/app/item.dart';

class Siderbar extends StatefulWidget {
  final String title;
  final Widget content;
  final Widget? button;

  const Siderbar({
    super.key,
    required this.title,
    required this.content,
    this.button,
  });

  @override
  State<Siderbar> createState() => _SiderbarState();
}

class _SiderbarState extends State<Siderbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('All Features', textAlign: TextAlign.center),
            ),
            Item(
              title: "User List",
              tap: () {
                NavLink.next(context, widget: UserPage(title: "User List"));
              },
            ),
            Item(
              title: "Weight Calculator",
              icon: Icons.calculate,
              tap: () {
                NavLink.next(context, widget: WeightCalculator());
              },
            ),
            Item(
              title: "Simple Calendar",
              icon: Icons.calendar_month,
              tap: () {
                NavLink.next(context, widget: SimpleCalendar());
              },
            ),
            Item(
              title: "Full Calendar",
              icon: Icons.perm_contact_calendar_rounded,
              tap: () {
                NavLink.next(context, widget: CalendarViewPage());
              },
            ),
            Item(
              title: "Music Player UI",
              icon: Icons.music_note,
              tap: () {
                NavLink.next(context, widget: MusicPlayer());
              },
            ),
            Item(
              title: "Timer / Stopwatch",
              icon: Icons.timer_sharp,
              tap: () {
                NavLink.next(context, widget: TimerStopwatch());
              },
            ),
            Item(
              title: "Calendar Notes",
              icon: Icons.edit_calendar,
              tap: () {
                NavLink.next(context, widget: CalendarNote());
              },
            ),
          ],
        ),
      ),
      body: widget.content,
      floatingActionButton: widget.button,
    );
  }
}
