import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/timers/stopwatch_view.dart';
import 'package:smple_app/views/widgets/app/tabbar.dart';
import 'package:smple_app/views/widgets/timers/timer_view.dart';

class TimerStopwatch extends StatefulWidget {
  const TimerStopwatch({super.key});

  @override
  State<TimerStopwatch> createState() => _TimerStopwatchState();
}

class _TimerStopwatchState extends State<TimerStopwatch>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Tabbar(
        title: 'Timer & Stopwatch',
        tabs: [Tab(text: 'Timer'), Tab(text: 'Stopwatch')],
        tabViews: [TimerView(), StopwatchView()],

        // button: Buttons.icon(
        //   pressed: () {
        //     service.showForm(context, null);
        //   },
        //   icon: Icons.add,
        //   color: Colors.white,
        // ),
      ),
    );
  }
}
