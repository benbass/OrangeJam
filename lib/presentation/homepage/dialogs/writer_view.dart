import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:orangejam/core/globals.dart';
import 'package:orangejam/core/metatags/overwrite_file.dart';
import 'package:orangejam/presentation/homepage/custom_widgets/custom_widgets.dart';
import 'package:path/path.dart';

import 'package:orangejam/domain/entities/track_entity.dart';
import '../../../application/listview/data/tracks_bloc.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../generated/l10n.dart';
import '../../../injection.dart' as di;

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
  late String fileName;
  final tracksBloc = BlocProvider.of<TracksBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  final playerControlsBloc = BlocProvider.of<PlayerControlsBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);

// Update DB object
  _updateDbObject() async {
    // Get the obj
    final track = di.trackBox.get(widget.track.id)!;
    // Modify obj properties
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

    // Update the obj
    di.trackBox.put(track);

    // Update the UI
    _updateUi(track);
  }

  _updateUi(TrackEntity track) {
    // list
    tracksBloc.add(TracksLoadingEvent());
    // player controls and track details if updated track is playback track
    if (track.id == playerControlsBloc.state.track.id) {
      playerControlsBloc.add(TrackMetaTagUpdated());
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
            const SizedBox(height: 12,),
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
                      btnText: S.of(context).edit_tags_selectPicture,
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
                labelText: S.of(context).edit_tags_trackTitle),
            MyTextInput(
                txtController: artistController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).artist),
            MyTextInput(
                txtController: albumController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).album),
            MyTextInput(
                txtController: albumArtistController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).albumArtist),
            MyTextInput(
                txtController: trackNumberController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).trackNo),
            MyTextInput(
                txtController: trackTotalController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).edit_tags_tracksTotal),
            MyTextInput(
                txtController: yearController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).year),
            MyTextInput(
                txtController: genreController,
                themeData: themeData,
                autoFocus: false,
                labelText: S.of(context).genre),
          ],
        ),
        actions: [
          SimpleButton(
            themeData: themeData,
            btnText: S.of(context).buttonCancel,
            function: () {
              Navigator.of(context).pop();
            },
          ),
          SimpleButton(
            themeData: themeData,
            btnText: S.of(context).save,
            function: saveUpdatedTrack,
          ),
        ],
        showDropdown: false,
        titleWidget: DescriptionText(
          themeData: themeData,
          description: S.of(context).edit_tags_editTags,
        ),
        themeData: themeData,
      ),
    );
  }

  void saveUpdatedTrack() async {
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

            // We send metadata to method where copy of original file will be created,
            // copy's metadata updated and this copy used to overwrite the original file
            OverwriteFile overwriteFile = OverwriteFile(metaData: metaData, file: file, fileName: fileName);
            bool? fileIsSaved = await overwriteFile.saveFileWithMediaStore();
            // Handle success / error writing to file
            if(fileIsSaved != null && fileIsSaved){
              Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
              ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
                  .showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                      S.of(globalScaffoldKey.scaffoldKey.currentContext!).edit_tags_snackBarUpdateSuccess(fileName)),
                ),
              );
              // ObjectBox item must also be updated so we avoid scanning device
              _updateDbObject();
            } else {
              Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
              ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
                  .showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                      S.of(globalScaffoldKey.scaffoldKey.currentContext!).edit_tags_snackBarUpdateError),
                ),
              );
            }
          }
}
