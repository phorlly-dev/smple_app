import 'package:flutter/material.dart';
import 'package:smple_app/core/services/audio_file_service.dart';

class MyPlayList extends StatelessWidget {
  const MyPlayList({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AudioFileService();

    return Container(
      padding: EdgeInsets.only(top: 20, left: 12, right: 12),
      child: Expanded(
        child: service.playListGroupedListView(context, service.mySongs),
      ),
    );
  }
}
