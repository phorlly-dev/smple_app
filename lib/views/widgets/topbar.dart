import 'package:flutter/material.dart';

class Topbar extends StatefulWidget {
  final String title;
  final Widget content;
  final Widget? button;

  const Topbar({
    super.key,
    required this.title,
    required this.content,
    this.button,
  });

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: widget.content,
      floatingActionButton: widget.button,
    );
  }
}
