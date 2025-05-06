import 'package:flutter/material.dart';

class TimerStopwatch extends StatelessWidget {
  const TimerStopwatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Timer Stopwatch',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
