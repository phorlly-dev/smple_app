import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/app/topbar.dart';

class CalendarNote extends StatelessWidget {
  const CalendarNote({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Calendar Note',
        content: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Calendar Note',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
