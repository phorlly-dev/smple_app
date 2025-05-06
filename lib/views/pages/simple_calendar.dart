import 'package:flutter/material.dart';

class SimpleCalendar extends StatelessWidget {
  const SimpleCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Simple Calendar',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
