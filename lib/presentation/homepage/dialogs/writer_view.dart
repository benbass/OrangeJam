import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:flutter/material.dart';
import 'package:orangejam/core/globals.dart';
import 'package:orangejam/presentation/homepage/custom_widgets/custom_widgets.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:path/path.dart' as path;

import 'package:orangejam/domain/entities/track_entity.dart';
import '../../../application/listview/tracklist/tracklist_bloc.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../core/metatags/metatags_handler.dart';
import '../../../generated/l10n.dart';
import '../../../injection.dart' as di;
import '../../../injection.dart';
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
  File? imgFromPicker;
  late File file;
  late TrackEntity trackForDb;
  late String fileName;
  final tracklistBloc = BlocProvider.of<TracklistBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  final playerControlsBloc = BlocProvider.of<PlayerControlsBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);

  // mediastore var
  final DirType dirType = DirType.audio;

// Update DB object
  _updateDbObject() async {
    final track = di.trackBox.get(widget.track.id)!;
    track.trackName = titleController.text;
    track.trackArtistNames = artistController.text;
    track.albumName = albumController.text;
    track.trackNumber = int.tryParse(trackNumberController.text);
    track.albumLength = int.tryParse(trackTotalController.text);
    track.year = int.tryParse(yearController.text);
    track.genre = genreController.text;
    track.trackDuration = widget.track.trackDuration;
    if (imgFromPicker != null) {
      track.albumArt = await imgFromPicker!.readAsBytes();
    }
    track.albumArtist = albumArtistController.text;

    di.trackBox.put(track);

    // Update the UI
    _updateUi(track);
  }

  _updateUi(TrackEntity track) {
    // list
    tracklistBloc.add(TrackListLoadingEvent());
    // player controls and track details if updated track is playback track
    if (track.id == playerControlsBloc.state.track.id) {
      playerControlsBloc.add(TrackMetaTagUpdated());
    }
  }

  /// We cannot write to a file in the music library that is not owned by the app.
  /// That's why we need first to create a file with updated metadata in the temp dir.
  /// Then we will use the MediaStore Plus plugin to overwrite the original file with this file
  Future<File> _saveUpdatedFileToTemporaryFile() async {
    // We create a new file and save it to temp dir:
    final dir = await path_provider.getTemporaryDirectory();
    final filePath = path.join(dir.path, fileName);

    // file must exist before we can write metadata to it so
    // we copy original file to temp dir:
    await file.copy(filePath);

    // we create metaTag from form
    Tag metaData = Tag(
      title: titleController.text,
      trackArtist: artistController.text,
      album: albumController.text,
      albumArtist: albumArtistController.text,
      genre: genreController.text,
      year: int.tryParse(yearController.text),
      trackNumber: int.tryParse(trackNumberController.text),
      trackTotal: int.tryParse(trackTotalController.text),
      pictures: imgFromPicker != null // User picked new image
          ? [
              Picture(
                  bytes: imgFromPicker!.readAsBytesSync(),
                  mimeType: null,
                  pictureType: PictureType.other)
            ]
          : widget.track.albumArt != null // User didn't pick new image: we keep the existing one, if any
              ? [
                  Picture(
                      bytes: widget.track.albumArt!,
                      mimeType: null,
                      pictureType: PictureType.other)
                ]
              : [],
    );

    // we write metaTag to temp file
    await sl<MetaTagsHandler>().writeTags(filePath, metaData);

    return File(filePath);
  }

  _saveFileWithMediaStore() async {
    // we need the temp file (file name is identical with original file)
    final File tempFile = await _saveUpdatedFileToTemporaryFile();

    // we overwrite the original file with temp file via mediaStore
    SaveInfo? saveInfo = await mediaStorePlugin.saveFile(
      relativePath: FilePath.root,
      tempFilePath: tempFile.path,
      dirType: dirType,
      dirName: DirName.music,
    );

    // if success, we update the objectBox object
    if (saveInfo?.uri != null) {
      _updateDbObject();
      ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
          .showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
              "The tags of the $fileName file have been successfully updated."),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.track.trackName);
    artistController =
        TextEditingController(text: widget.track.trackArtistNames?.toString());
    albumController = TextEditingController(text: widget.track.albumName?.toString());
    albumArtistController =
        TextEditingController(text: widget.track.albumArtist?.toString());
    genreController = TextEditingController(text: widget.track.genre?.toString());
    trackNumberController =
        TextEditingController(text: widget.track.trackNumber?.toString());
    trackTotalController =
        TextEditingController(text: widget.track.albumLength?.toString());
    yearController = TextEditingController(text: widget.track.year?.toString());
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
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: CustomDialog(
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    image: imgFromPicker != null
                        ? DecorationImage(
                            image:
                                MemoryImage(imgFromPicker!.readAsBytesSync()),
                            fit: BoxFit.cover,
                          )
                        : widget.track.albumArt != null
                            ? DecorationImage(
                                image: MemoryImage(widget.track.albumArt!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image:
                                    AssetImage("assets/album-placeholder.png"),
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleButton(
                      themeData: themeData,
                      btnText: "Select a picture",
                      function: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                        );

                        if (result != null) {
                          imgFromPicker = File(result.files.single.path!);
                          setState(() {});
                        }
                      },
                    ),
                    /*
                    TextButton(
                      style: TextButton.styleFrom(
                        // We remove the inner padding with the next 3 lines
                        minimumSize: const Size(54, 30),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        textStyle: themeData.textTheme.bodyMedium,
                      ),
                      child: const Text("Device"),
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(40, 30),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: themeData.textTheme.bodyMedium,
                      ),
                      child: const Text("Web"),
                      onPressed: () {},
                    ),
                    */
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextInput(
                txtController: titleController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Title"),
            MyTextInput(
                txtController: artistController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Artist"),
            MyTextInput(
                txtController: albumController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Album"),
            MyTextInput(
                txtController: albumArtistController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Album artist"),
            MyTextInput(
                txtController: trackNumberController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Track number"),
            MyTextInput(
                txtController: trackTotalController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Tracks total"),
            MyTextInput(
                txtController: yearController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Year"),
            MyTextInput(
                txtController: genreController,
                themeData: themeData,
                autoFocus: false,
                labelText: "Genre"),
          ],
        ),
        actions: [
          SimpleButton(
            themeData: themeData,
            btnText: "Cancel",
            function: () {
              Navigator.of(context).pop();
            },
          ),
          SimpleButton(
            themeData: themeData,
            btnText: "Save",
            function: () {
              _saveFileWithMediaStore();
              Navigator.of(context).pop();
            },
          ),
        ],
        showDropdown: false,
        titleWidget: DescriptionText(
          themeData: themeData,
          description: "Edit tags",
        ),
        themeData: themeData,
      ),
    );
  }
}
