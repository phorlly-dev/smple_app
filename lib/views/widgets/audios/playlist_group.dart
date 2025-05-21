import 'package:flutter/material.dart';
import 'package:smple_app/core/views/audio_view.dart';

class MyPlayList extends StatelessWidget {
  const MyPlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 12, right: 12),
      child: Expanded(
        child: AudioView.playListGroupedListView(context, AudioView.mySongs),
      ),
    );
  }
}
