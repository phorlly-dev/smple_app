import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smple_app/core/functions/index.dart';
import 'package:smple_app/core/links/nav_link.dart';
import 'package:smple_app/core/models/timer_item.dart';
import 'package:smple_app/views/widgets/generals/sample.dart';
import 'package:smple_app/views/widgets/timers/timer_countdown.dart';

class TimerView extends StatelessWidget {
  final Function(TimerData)? onTimerCreated;
  const TimerView({super.key, this.onTimerCreated});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    int selectedHours = 0;
    int selectedMinutes = 1;
    int selectedSeconds = 0;
    int totalTime = 60;
    int remainingTime = 60;
    Timer? countdownTimer;
    bool isRunning = false;

    return StatefulBuilder(
      builder: (context, setState) {
        void calculateTotalSeconds() {
          totalTime =
              selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds;
          if (totalTime > 359999) totalTime = 359999;
          remainingTime = totalTime;
        }

        String format(int totalSeconds) {
          int h = totalSeconds ~/ 3600;
          int m = (totalSeconds % 3600) ~/ 60;
          int s = totalSeconds % 60;
          return "${h.bitLength > 0 ? '${Funcs.numToStr(h)}:' : ''}${Funcs.numToStr(m)}:${Funcs.numToStr(s)}";
        }

        //stop the timer
        void stop() {
          countdownTimer?.cancel();
          setState(() => isRunning = false);
        }

        //reset data
        void reset() {
          stop();
          setState(() => calculateTotalSeconds());
          titleController.clear();
        }

        void start() {
          calculateTotalSeconds();
          final title = titleController.text.trim();
          if (title.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please enter a title for the timer.')),
            );
            return;
          }

          if (!isRunning && remainingTime > 0) {
            // saveTimerToFirebase(title, totalTime);
            countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
              setState(() {
                if (remainingTime > 0) {
                  remainingTime--;
                } else {
                  countdownTimer?.cancel();
                  isRunning = false;
                }
              });
            });
            final newTimer = TimerData(
              id: DateTime.now().toIso8601String(),
              title: title,
              totalTime: totalTime,
              remainingTime: totalTime,
            );

            Navigator.pop(context, newTimer);

            setState(() => isRunning = true);

            NavLink.go(
              context: context,
              screen: TimerCountdown(
                title: title,
                totalTime: totalTime,
                format: format,
                onStop: reset,
              ),
            );
          }
        }

        Widget buildTimePicker() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hours
              TimerSelector(
                label: "Hours",
                count: 100,
                selected: selectedHours,
                onChanged: (val) => setState(() => selectedHours = val),
              ),
              // Minutes
              TimerSelector(
                label: "Minutes",
                count: 60,
                selected: selectedMinutes,
                onChanged: (val) => setState(() => selectedMinutes = val),
              ),
              // Seconds
              TimerSelector(
                label: "Seconds",
                count: 60,
                selected: selectedSeconds,
                onChanged: (val) => setState(() => selectedSeconds = val),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Start Countdown!',
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Input(
                label: "Tile",
                hint: 'Enter a title',
                name: titleController,
                icon: Icons.note_alt_rounded,
              ),
              const SizedBox(height: 20),
              Text(
                format(remainingTime),
                style: const TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              buildTimePicker(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(label: 'Start', click: start, icon: Icons.play_arrow),
                  Button(
                    label: 'Reset',
                    click: reset,
                    icon: Icons.refresh,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
