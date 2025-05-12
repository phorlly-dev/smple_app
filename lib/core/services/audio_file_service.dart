import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/audio_file.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/widgets/sample.dart';

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

  // Stream builder for reusable widget
  liveStream(BuildContext context) {
    return Service.streamBuilder<AudioFile>(
      collectionName: 'audioFiles',
      fromMap: (data, docId) => AudioFile.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            log('The item: $item');

            return ListTile(
              leading: Text("Left"),
              title: Text('My Title'),
              subtitle: Text(
                'My Subtitle',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: Text("Right"),
              // trailing: ActionButtons(
              //   pressedOnDelete: () {
              //     Global.confirmDelete(
              //       context,
              //       message: object.name,
              //       confirmed: () {
              //         Navigator.of(context).pop();
              //         remove(object.id);

              //         // Optionally refresh the UI or show a snackbar
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text('Deleted successfully')),
              //         );
              //       },
              //     );
              //   },
              //   pressedOnEdit: () {
              //     showForm(context, object);
              //   },
              // ),
            );
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
    final duration = TextEditingController(
      text:
          item?.duration != null
              ? item!.duration.toString()
              : Duration(milliseconds: 0).toString(),
    );
    bool isFavorite = false;

    // Show the dialog
    Global.showModal(
      context: context,
      builder: (context, setState) {
        return Global.form(
          model: item,
          context,
          title: 'Event',
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
            TextFormField(
              controller: duration,
              decoration: const InputDecoration(labelText: 'Duration (mm:ss)'),
              validator:
                  (value) => value!.contains(':') ? null : 'Format: mm:ss',
            ),
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
                        await Global.showFile().then((val) {
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
                        await Global.showFile(isGallery: false).then((val) {
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
                    SizedBox(width: 50),
                    ImageFile(image: artworkImage, wh: 60, hb: 60),
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
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Submit')),
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
              title.clear();

              if (context.mounted) {
                Navigator.pop(context);
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

  String artworkImage = "";
  final ImagePicker picker = ImagePicker();

  Future<void> pickArtworkImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      artworkImage = File(pickedFile.path) as String;

      // log("Picked file path: $artworkImage");
    }
  }
}
