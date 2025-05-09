import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class TimerStopwatch extends StatelessWidget {
  const TimerStopwatch({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Timer Stopwatch',
        content: Center(child: Global.text('Timer Stopwatch')),
      ),
    );
  }
}
