import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: 'Music Player UI',
        content: Center(child: Global.text('Music Player UI')),
      ),
    );
  }
}
