import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      );
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration, DurationState>(
        _player.positionStream,
        _player.durationStream.whereType<Duration>(),
        (position, duration) => DurationState(position, duration),
      );

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: "Music Player",
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.music_note, size: 100),
              const SizedBox(height: 20),
              StreamBuilder<DurationState>(
                stream: _durationStateStream,
                builder: (context, snapshot) {
                  final durationState = snapshot.data;
                  final position = durationState?.position ?? Duration.zero;
                  final total = durationState?.total ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        min: 0.0,
                        max: total.inMilliseconds.toDouble(),
                        value: position.inMilliseconds.toDouble().clamp(
                          0.0,
                          total.inMilliseconds.toDouble(),
                        ),
                        onChanged: (value) {
                          _player.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Text(
                        "${_formatDuration(position)} / ${_formatDuration(total)}",
                      ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _player.play(),
                    iconSize: 40,
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => _player.pause(),
                    iconSize: 40,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () => _player.stop(),
                    iconSize: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState(this.position, this.total);
}
