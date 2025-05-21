import 'package:flutter/material.dart';
import 'package:smple_app/core/views/audio_view.dart';

class MySong extends StatelessWidget {
  const MySong({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 12, right: 12),
      child: Expanded(
        child: AudioView.audioFileListView(context, AudioView.mySongs),
      ),
    );
  }
}
