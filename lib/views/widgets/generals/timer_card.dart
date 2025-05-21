import 'package:flutter/material.dart';
import 'package:smple_app/core/functions/index.dart';
import 'package:smple_app/core/models/timer_item.dart';

class TimerCard extends StatelessWidget {
  final TimerData timer;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const TimerCard({
    super.key,
    required this.timer,
    required this.onPause,
    required this.onStop,
  });

  String format(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return "${h > 0 ? '${Funcs.numToStr(h)}:' : ''}${Funcs.numToStr(m)}:${Funcs.numToStr(s)}";
    // return "${h > 0 ? '$h:' : ''}${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(timer.title, style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(format(timer.remainingTime), style: TextStyle(fontSize: 32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: onStop, icon: Icon(Icons.stop)),
                IconButton(
                  onPressed: onPause,
                  icon: Icon(timer.isPaused ? Icons.play_arrow : Icons.pause),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
