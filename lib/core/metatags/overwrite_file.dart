import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:audiotags/audiotags.dart';
//import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

import '../../injection.dart';
import '../globals.dart';
import 'metatags_handler.dart';

class OverwriteFile {
  final Tag metaData;
  final File file;
  final String fileName;

  OverwriteFile({
    required this.metaData,
    required this.file,
    required this.fileName,
  });

  /// We cannot write to a file in the music library that is not owned by the app.
  /// That's why we need first to create a file with updated metadata in the temp dir.
  /// Then we will use the MediaStore Plus plugin to overwrite the original file with this file
  Future<File> _saveUpdatedFileToTemporaryFile(BuildContext context) async {
    // We create a new file and save it to temp dir:
    final dir = await path_provider.getTemporaryDirectory();
    final filePath = path.join(dir.path, fileName);

    // file must exist before we can write metadata to it so
    // we copy original file to temp dir:
    await file.copy(filePath);

    // we write metaTag to temp file
    if (context.mounted) {
      await sl<MetaTagsHandler>().writeTags(filePath, metaData, context);
    }
    // returns temp file
    return File(filePath);
  }

  Future<bool?> saveFileWithMediaStore(BuildContext context) async {
    // we need the temp file (file name is identical with original file)
    final File tempFile = await _saveUpdatedFileToTemporaryFile(context);

    // we overwrite the original file with temp file via mediaStore
    SaveInfo? saveInfo = await mediaStorePlugin.saveFile(
      relativePath: FilePath.root,
      tempFilePath: tempFile.path,
      dirType: DirType.audio,
      dirName: DirName.music,
    );

    if (saveInfo != null) {
      return saveInfo.isSuccessful;
    }
    return null;
  }
}
