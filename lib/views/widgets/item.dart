import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';

class Item extends StatelessWidget {
  // This widget is the root of your application.
  final String title;
  final VoidCallback tap;

  const Item({super.key, required this.title, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 0,
      child: ListTile(title: Global.text(title), onTap: tap),
    );
  }
}
