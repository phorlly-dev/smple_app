import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smple_app/core/links/nav_link.dart';
import 'package:smple_app/core/models/timer_item.dart';
import 'package:smple_app/core/services/timer_servce.dart';
import 'package:smple_app/views/widgets/app/topbar.dart';
import 'package:smple_app/views/widgets/generals/sample.dart';
import 'package:smple_app/views/widgets/generals/timer_card.dart';
import 'package:smple_app/views/widgets/timers/timer_view.dart';

class TimerCountdown extends StatefulWidget {
  final String title;
  final int totalTime;
  final String Function(int) format;
  final VoidCallback onStop;

  const TimerCountdown({
    super.key,
    required this.totalTime,
    required this.format,
    required this.onStop,
    required this.title,
  });

  @override
  State<TimerCountdown> createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  List<TimerData> activeTimers = [];
  late int remainingTime;
  Timer? countdownTimer;
  late String editableTitle;
  final service = TimerServce();
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.totalTime;
    editableTitle = widget.title;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            countdownTimer?.cancel();
            saveTo(); //Save when timer ends
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text("Timer Finished"),
                  content: Text(
                    "Your timer \"$editableTitle\" has been saved.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void handleStop() {
    countdownTimer?.cancel();
    saveTo();

    Navigator.pop(context);
    widget.onStop();
  }

  void togglePause() {
    if (isPaused) {
      // Resume
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (remainingTime > 0) {
              remainingTime--;
            } else {
              countdownTimer?.cancel();
            }
          });
        }
      });

      setState(() {
        isPaused = false;
      });
    } else {
      // Pause
      countdownTimer?.cancel();

      setState(() {
        isPaused = true;
      });
    }
  }

  void editTitle() async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: widget.title);
        return AlertDialog(
          title: Text('Edit Title', textAlign: TextAlign.center),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      setState(() {
        editableTitle = newTitle; // Change to stateful handling if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        backIcon: false,
        title: "Timer",
        content: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: activeTimers.length,
              itemBuilder: (context, index) {
                final timer = activeTimers[index];

                return TimerCard(
                  timer: timer,
                  onPause: () {
                    setState(() => timer.isPaused = !timer.isPaused);
                  },
                  onStop: () async {
                    timer.countdown?.cancel();
                    setState(() => activeTimers.removeAt(index));
                    await service.store(
                      TimerItem(
                        id: timer.id,
                        title: timer.title,
                        duration: timer.totalTime,
                        startTime: DateTime.now(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            Button(
              label: 'Add another timer',
              click: () {
                NavLink.go(
                  context: context,
                  screen: TimerView(
                    onTimerCreated: (value) {
                      setState(() {
                        activeTimers.add(value);
                      });
                    },
                  ),
                );
              },
              icon: Icons.add,
              color: Colors.lightBlueAccent,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  // save the data to database
  Future<void> saveTo() async {
    await service.store(
      TimerItem(
        id: '',
        title: editableTitle,
        duration: widget.totalTime,
        startTime: DateTime.now(),
      ),
    );
  }
}
