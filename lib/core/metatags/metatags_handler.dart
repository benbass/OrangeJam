import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:audiotags/audiotags.dart';

import '../../domain/entities/track_entity.dart';
import '../../infrastructure/models/track_model.dart';

class MetaTagsHandler{

  // We use MetadataGod to read
  Future<TrackEntity> readTags(File file) =>
    MetadataGod.readMetadata(
      file: file.path,
    ).then(
          (value) async =>
      // value throws a parseErrorData from dependency package FlutterRustBridgeBase for some files: some metadata may be corrupt or package is buggy?
      await Future.sync(() => TrackModel.metaData(value, file))
          .then((value) => value),
    );

  // We use AudioTags to write: MetadataGod doesn't write album art at all (!!!). Reason unknown...
  writeTags(String filePath, Tag metaData, BuildContext context) async {
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