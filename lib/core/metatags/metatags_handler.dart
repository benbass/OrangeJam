import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

import '../../domain/entities/track_entity.dart';
import '../../infrastructure/models/track_model.dart';

class MetaTagsHandler {
  // We use MetadataGod to read
  Future<TrackEntity> readTags(File file) => MetadataGod.readMetadata(
        file: file.path,
      ).then(
        (value) async =>
            // value throws a parseErrorData from dependency package FlutterRustBridgeBase for some files: some metadata may be corrupt or package is buggy?
            // MetadataGod updated to v. 1.0.0: app can now be built for iOS
            await Future.sync(() => TrackModel.metaData(value, file))
                .then((value) => value),
      );

  // With update of MetadataGod to v. 1.0.0 we can now write albumArt so we use this package for writing as well. We removed audiotags-package that we used before.
  // This step resolves the issue building app for iOS !!! :-)
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
}
