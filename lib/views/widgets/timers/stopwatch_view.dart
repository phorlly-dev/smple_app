import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smple_app/core/models/lab_record.dart';

class StopwatchView extends StatefulWidget {
  const StopwatchView({super.key});

  @override
  State<StopwatchView> createState() => _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  final List<String> _lapTimes = [];

  String _formattedTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:"
        "${twoDigits(duration.inSeconds % 60)}."
        "${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      setState(() {});
    });
    _stopwatch.start();
  }

  void _stopTimer() {
    _timer.cancel();
    _stopwatch.stop();
  }

  void _resetTimer() {
    _stopwatch.reset();
    setState(() {
      _lapTimes.clear();
    });
  }

  void _recordLap() {
    final current = _formattedTime(_stopwatch.elapsed);
    setState(() {
      _lapTimes.insert(0, current);
    });
  }

  Future<void> _saveToFirebase() async {
    final record = LapRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      lapTimes: _lapTimes,
      totalTime: _formattedTime(_stopwatch.elapsed),
      createdAt: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('lap_records')
        .doc(record.id)
        .set(record.toMap());

    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _formattedTime(_stopwatch.elapsed);

    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            elapsed,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _startTimer, child: Text('Start')),
              ElevatedButton(onPressed: _stopTimer, child: Text('Stop')),
              ElevatedButton(onPressed: _resetTimer, child: Text('Reset')),
              ElevatedButton(onPressed: _recordLap, child: Text('Lap')),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveToFirebase,
            child: Text('Save to Firebase'),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _lapTimes.length,
              itemBuilder: (context, index) {
                return Center(
                  child: ListTile(
                    title: Text(
                      'Lap ${_lapTimes.length - index}: ${_lapTimes[index]}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
