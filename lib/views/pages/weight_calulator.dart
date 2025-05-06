import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class WeightCalulator extends StatelessWidget {
  const WeightCalulator({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        content: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Weight Calulator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: 'Weight Calulator',
      ),
    );
  }
}
