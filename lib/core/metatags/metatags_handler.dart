import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

import '../../domain/entities/track_entity.dart';
import '../../infrastructure/models/track_model.dart';

///TODO: Considering using other metadata plugin like audiotags to solve build issues causes by metadata_god depending on target platform
///Problem: other plugins do not read all tags correctly.
///Audiotags for ex. doesn't read the genre. And as per Issues on GitHub, it seems there is also a problem building app for iOS
class MetaTagsHandler {
  /// READ
  // version for metadata_god
 Future<TrackEntity> readTags(File file) => MetadataGod.readMetadata(
        file: file.path,
      ).then(
        (value) async =>
            await Future.sync(() => TrackModel.metaData(value, file))
                .then((value) => value),
      );

 // version for audiotags
 /* Future<TrackEntity> readTags(File file) => AudioTags.read(file.path,)
      .then(
        (value) async =>
    await Future.sync(() => TrackModel.metaData(value!, file))
        .then((value) => value),
  );*/

  /// WRITE
  // This method uses metadata_god: artwork is not updated correctly unless we could use version 1.0.0, which is not compatible with Android on real device
 /*
  writeTags(String filePath, Metadata metaData, BuildContext context) async {
    try {
      await MetadataGod.writeMetadata(
        file: filePath,
        metadata: metaData,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text("ERROR: \n$e"),
          ),
        );
      }
    }
  }
  */

  // We use AudioTags to write: MetadataGod doesn't always write album art so it's not updated. Reason unknown...
  Future<void> writeTags(String filePath, Tag metaData, BuildContext context) async {
    try{
      await AudioTags.write(
        filePath,
        metaData,
      );
    } catch(e){
      if(context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
                "ERROR: \n$e"),
          ),
        );
      }
    }
  }
}
