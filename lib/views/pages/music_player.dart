import 'package:flutter/material.dart';
import 'package:smple_app/core/services/audio_file_service.dart';
import 'package:smple_app/views/widgets/album_group.dart';
import 'package:smple_app/views/widgets/playlist_group.dart';
import 'package:smple_app/views/widgets/song.dart';
import 'package:smple_app/views/widgets/tabbar.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final service = AudioFileService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Tabbar(
        title: 'Music Player UI',
        tabs: const [
          Tab(text: 'Songs'),
          Tab(text: 'Playlists'),
          // Tab(text: 'Folders'),
          Tab(text: 'Albums'),
        ],
        tabViews: const [
          // Center(child: Text('My Song')),
          Center(child: MySong()),

          Center(child: MyPlayList()),
          // Center(
          //   child: ImageAsset(
          //     w: 370,
          //     h: 200,
          //     path:
          //         '/data/user/0/com.example.smple_app/app_flutter/assets/images/56f15cc2-970a-4093-aa43-1677589e79ad6181823022235219242.jpg',
          //   ),
          // ),
          Center(child: MyAlbum()),
        ],

        // button: Buttons.icon(
        //   pressed: () {
        //     service.showForm(context, null);
        //   },
        //   icon: Icons.add,
        //   color: Colors.white,
        // ),
      ),
    );
  }
}
