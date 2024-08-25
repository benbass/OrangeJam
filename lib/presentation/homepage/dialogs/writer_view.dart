import 'dart:io';

import 'package:media_store_plus/media_store_plus.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:path/path.dart' as path;

import 'package:orangejam/domain/entities/track_entity.dart';
import '../../../main.dart';

class WriterView extends StatefulWidget {
  final TrackEntity track;
  const WriterView({
    super.key,
    required this.track,
  });

  @override
  State<WriterView> createState() => _WriterViewState();
}

class _WriterViewState extends State<WriterView> {
  late TextEditingController titleController;
  late TextEditingController artistController;
  late TextEditingController albumController;
  late TextEditingController albumArtistController;
  late TextEditingController trackNumberController;
  late TextEditingController trackTotalController;
  late TextEditingController yearController;
  late TextEditingController genreController;
  late TextEditingController pictureController;
  late File file;
  late TrackEntity trackForDb;
  late String fileName;

  // mediastore
  final DirType dirType = DirType.audio;

  updateFileMetadataAndDbObject() async {
    /// TODO: solve duplicate instead of update issue
    // Update DB object
    /*
    trackBox.put(
      widget.track.copyWith(
        trackName: titleController.text,
        trackArtistNames: artistController.text,
        albumName: albumController.text,
        trackNumber: int.tryParse(trackNumberController.text),
        albumLength: int.tryParse(trackTotalController.text),
        year: int.tryParse(yearController.text),
        genre: genreController.text,

        /// Todo: update picture!!!
        //albumArt: widget.track.albumArt,
        albumArtist: albumArtistController.text,
      ),
    );
    */
  }

  /// We cannot write to a file in the music library that is not owned by the app.
  /// That's why we need first to create a file with updated metadata in the temp dir.
  /// Then we will use the MediaStore Plus plugin to overwrite the original file with this file
  Future<File> _saveUpdatedFileToTemporaryFile() async {
    // We create a new file and save it to temp dir:
    final dir = await path_provider.getTemporaryDirectory();
    final filePath = path.join(dir.path, fileName);

    // MetadataGod.writeMetadata() needs file to exist before it can write metadata to it so
    // we copy original file to temp dir:
    await file.copy(filePath);

    // Then we write metadata to the copy
    await MetadataGod.writeMetadata(
      file: filePath,
      metadata: Metadata(
        album: albumController.text,
        albumArtist: albumArtistController.text,
        artist: artistController.text,
        genre: genreController.text,

        /// Todo: update picture
        picture: widget.track.albumArt != null
            ? Picture(mimeType: '', data: widget.track.albumArt!)
            : null,
        title: titleController.text,
        trackNumber: int.tryParse(trackNumberController.text),
        trackTotal: int.tryParse(trackTotalController.text),
        year: int.tryParse(yearController.text),
      ),
    );
    return File(filePath);
  }

  _saveFileWithMediaStore() async {
    // we need the temp file (file name is identical with original file)
    final File tempFile = await _saveUpdatedFileToTemporaryFile();

    // we overwrite the original file with temp file
    await mediaStorePlugin.saveFile(
      relativePath: FilePath.root,
      tempFilePath: tempFile.path,
      dirType: dirType,
      dirName: DirName.music,
    );
  }


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.track.trackName);
    artistController =
        TextEditingController(text: widget.track.trackArtistNames);
    albumController = TextEditingController(text: widget.track.albumName);
    albumArtistController =
        TextEditingController(text: widget.track.albumArtist);
    genreController = TextEditingController(text: widget.track.genre);
    trackNumberController =
        TextEditingController(text: widget.track.trackNumber.toString());
    trackTotalController =
        TextEditingController(text: widget.track.albumLength.toString());
    yearController = TextEditingController(text: widget.track.year.toString());
    pictureController =
        TextEditingController(text: widget.track.albumArt.toString());
    file = File(widget.track.filePath);
    fileName = basename(file.path);
  }

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    albumController.dispose();
    albumArtistController.dispose();
    trackNumberController.dispose();
    trackTotalController.dispose();
    yearController.dispose();
    genreController.dispose();
    pictureController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AlertDialog(
        scrollable: true,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _saveFileWithMediaStore();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
        title: const Text("Write Metadata"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "title"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: artistController,
              decoration: const InputDecoration(labelText: "artist"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: albumController,
              decoration: const InputDecoration(labelText: "album"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: albumArtistController,
              decoration: const InputDecoration(labelText: "albumArtist"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: trackNumberController,
              decoration: const InputDecoration(labelText: "trackNumber"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: trackTotalController,
              decoration: const InputDecoration(labelText: "trackTotal"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: yearController,
              decoration: const InputDecoration(labelText: "year"),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: genreController,
              decoration: const InputDecoration(labelText: "genre"),
            ),
          ],
        ),
      ),
    );
  }

}
