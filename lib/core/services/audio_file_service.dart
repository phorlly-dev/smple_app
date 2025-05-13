import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/common/nav_link.dart';
import 'package:smple_app/core/models/audio_file.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/widgets/sample.dart';
import 'package:smple_app/views/widgets/song_player.dart';

class AudioFileService {
  Future<List<AudioFile>> index() {
    return Service.readAll(
      collectionName: 'audioFiles',
      fromMap: (data, id) => AudioFile.fromMap(data, id),
    );
  }

  // Add a new
  Future<void> store(AudioFile object) async {
    await Service.create<AudioFile>(
      model: object,
      collectionName: 'audioFiles',
      toMap: (value) => value.toMap(),
    );
  }

  // Update an existing AudioFile
  Future<void> update(AudioFile object) async {
    // Update the AudioFile in Firestore
    await Service.update(
      collectionName: 'audioFiles',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Delete an AudioFile by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'audioFiles', docId: id);
  }

  Map<String, List<AudioFile>> groupByAlbum(List<AudioFile> songs) {
    final Map<String, List<AudioFile>> grouped = {};
    for (var song in songs) {
      if (!grouped.containsKey(song.album)) {
        grouped[song.album] = [];
      }
      grouped[song.album]!.add(song);
    }
    return grouped;
  }

  Map<String, List<AudioFile>> groupByPlayList(List<AudioFile> songs) {
    final Map<String, List<AudioFile>> grouped = {};
    for (var song in songs) {
      if (!grouped.containsKey(song.artist)) {
        grouped[song.artist] = [];
      }
      grouped[song.artist]!.add(song);
    }

    return grouped;
  }

  // Stream builder for reusable widget
  Widget liveStream(BuildContext context) {
    return Service.streamBuilder<AudioFile>(
      collectionName: 'audioFiles',
      fromMap: (data, docId) => AudioFile.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            log('The item: ${item.title} by ${item.artist}');

            return ListTile(
              leading: ImageAssetAvatr(path: item.artworkUrl),
              title: Text(item.title),
              subtitle: Text('${item.artist} • ${item.album}'),
              trailing: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : null,
              ),
              onTap: () {
                NavLink.go(
                  context: context,
                  screen: SongPlayer(audioFile: item),
                );
                log("Tapped on ${item.title}");
              },
            );
          },
        );
      },
    );
  }

  Widget albumGroupedListView(BuildContext context, List<AudioFile> songs) {
    final groupedSongs = groupByAlbum(songs);

    return ListView(
      children:
          groupedSongs.entries.map((entry) {
            final albumName = entry.key;
            final albumSongs = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    albumName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...albumSongs.map((song) {
                  return ListTile(
                    leading: ImageAsset(path: song.artworkUrl),
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    trailing: Icon(
                      song.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: song.isFavorite ? Colors.red : null,
                    ),
                    onTap: () {
                      NavLink.go(
                        context: context,
                        screen: SongPlayer(audioFile: song),
                      );
                    },
                  );
                }),
              ],
            );
          }).toList(),
    );
  }

  Widget playListGroupedListView(BuildContext context, List<AudioFile> songs) {
    final groupedSongs = groupByPlayList(songs);

    return ListView(
      children:
          groupedSongs.entries.map((entry) {
            final albumName = entry.key;
            final albumSongs = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    albumName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...albumSongs.map((song) {
                  return ListTile(
                    leading: ImageAsset(path: song.artworkUrl),
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    trailing: Icon(
                      song.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: song.isFavorite ? Colors.red : null,
                    ),
                    onTap: () {
                      NavLink.go(
                        context: context,
                        screen: SongPlayer(audioFile: song),
                      );
                    },
                  );
                }),
              ],
            );
          }).toList(),
    );
  }

  Widget audioFileListView(BuildContext context, List<AudioFile> audioFiles) {
    return ListView.builder(
      itemCount: audioFiles.length,
      itemBuilder: (context, index) {
        final item = audioFiles[index];

        return ListTile(
          leading: ImageAsset(path: item.artworkUrl),
          title: Text(item.title),
          subtitle: Text('${item.artist} • ${item.album}'),
          trailing: Icon(
            item.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: item.isFavorite ? Colors.red : null,
          ),
          onTap: () {
            NavLink.go(context: context, screen: SongPlayer(audioFile: item));
            // log("Tapped on ${item.title}");
          },
        );
      },
    );
  }

  // Function to show the form dialog for adding/editing a user
  void showForm(BuildContext context, AudioFile? item) {
    final title = TextEditingController(text: item?.title ?? '');
    final artist = TextEditingController(text: item?.artist ?? '');
    final album = TextEditingController(text: item?.album ?? '');
    final url = TextEditingController(text: item?.url ?? '');
    // final duration = TextEditingController(
    //   text:
    //       item?.duration != null
    //           ? item!.duration.toString()
    //           : Duration(milliseconds: 0).toString(),
    // );
    bool isFavorite = false;
    String artworkImage = '';

    // Show the dialog
    Global.showModal(
      context: context,
      builder: (context, setState) {
        return Global.form(
          model: item,
          context,
          title: 'Song',
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value!.isEmpty ? 'Enter title' : null,
            ),
            TextFormField(
              controller: artist,
              decoration: const InputDecoration(labelText: 'Artist'),
              validator: (value) => value!.isEmpty ? 'Enter artist' : null,
            ),
            TextFormField(
              controller: album,
              decoration: const InputDecoration(labelText: 'Album'),
            ),
            // TextFormField(
            //   controller: duration,
            //   decoration: const InputDecoration(labelText: 'Duration (mm:ss)'),
            //   validator:
            //       (value) => value!.contains(':') ? null : 'Format: mm:ss',
            // ),
            TextFormField(
              controller: url,
              decoration: const InputDecoration(labelText: 'Audio URL'),
              validator: (value) => value!.isEmpty ? 'Enter URL' : null,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Artwork Image', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Service.imagePickup(isCamera: false).then((val) {
                          setState(() => artworkImage = val);
                          log("Picked file path: $artworkImage");
                        });
                      },
                      icon: Icon(
                        Icons.image_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Service.imagePickup().then((val) {
                          setState(() => artworkImage = val);
                          log("Picked file path: $artworkImage");
                        });
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                    Spacer(),
                    ImageFile(image: artworkImage, w: 80, h: 100),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: isFavorite,
              onChanged: (val) => setState(() => isFavorite = val),
              title: const Text('Favorite'),
            ),
          ],

          // Save button
          onSave: () async {
            if (title.text.isEmpty) {
              Global.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              await store(
                AudioFile(
                  id: "",
                  title: title.text,
                  artist: artist.text,
                  album: album.text,
                  duration: Duration(minutes: 3, seconds: 45),
                  url: url.text,
                  artworkUrl: artworkImage,
                ),
              );

              if (context.mounted) {
                Navigator.pop(context);
                // title.clear();
                Global.message(context, message: 'Created successfully!');
              }
            }
          },

          // Update button
          onUpdate: () async {
            if (title.text.isEmpty) {
              Global.message(
                context,
                message: 'Please enter a title',
                bgColor: Colors.red,
              );
              return;
            } else {
              if (context.mounted) {
                Navigator.pop(context);
                Global.message(
                  context,
                  message: 'Updated successfully!',
                  bgColor: Colors.green,
                );
              }
            }
          },
        );
      },
    );
  }

  final List<AudioFile> mySongs = [
    AudioFile(
      id: '1',
      title: 'Yung Kai Blue',
      artist: 'Official MV',
      album: 'Vol 1',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/1.mp3',
      artworkUrl: 'assets/images/2.png',
      isFavorite: true,
    ),
    AudioFile(
      id: '2',
      title: 'Night Changes',
      artist: 'One Direction',
      album: 'Vol 1',
      duration: Duration(minutes: 3, seconds: 45),
      url: 'assets/audios/2.mp3',
      artworkUrl: 'assets/images/1.png',
      isFavorite: true,
    ),
    AudioFile(
      id: '3',
      title: 'Ed Sheeran  Perfect',
      artist: 'Lyric',
      album: 'Vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/3.mp3',
      artworkUrl: 'assets/images/3.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '4',
      title: 'Yellow',
      artist: 'Coldplay',
      album: 'Vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/4.mp3',
      artworkUrl: 'assets/images/4.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '5',
      title: 'The Scientis',
      artist: 'Coldplay',
      album: 'Vol 1',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/5.mp3',
      artworkUrl: 'assets/images/5.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '6',
      title: 'Numb',
      artist: 'Linkin Park',
      album: 'Vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/6.mp3',
      artworkUrl: 'assets/images/6.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '7',
      title: 'Counting Stars',
      artist: 'OneRepublic',
      album: 'vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/7.mp3',
      artworkUrl: 'assets/images/7.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '8',
      title: 'Here Without You',
      artist: '3 Doors Down',
      album: 'Vol 1',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/8.mp3',
      artworkUrl: 'assets/images/8.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '9',
      title: 'We Will Rock You',
      artist: 'Queen',
      album: 'Vol 3',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/9.mp3',
      artworkUrl: 'assets/images/9.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '10',
      title: 'Alone',
      artist: 'Marshmello',
      album: 'Vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/10.mp3',
      artworkUrl: 'assets/images/10.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '11',
      title: 'The Lazy Song',
      artist: 'Bruno Mars',
      album: 'Vol 2',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/11.mp3',
      artworkUrl: 'assets/images/11.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '12',
      title: 'Maroon 5 - Girls Like You ft. Cardi B',
      artist: 'Maroon 5',
      album: 'Vol 1',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/12.mp3',
      artworkUrl: 'assets/images/12.png',
      isFavorite: false,
    ),
    AudioFile(
      id: '13',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      album: 'Vol 3',
      duration: Duration(minutes: 4, seconds: 12),
      url: 'assets/audios/13.mp3',
      artworkUrl: 'assets/images/13.png',
      isFavorite: false,
    ),
  ];
}
