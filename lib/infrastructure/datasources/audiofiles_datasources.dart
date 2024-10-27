import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart';

import '../../services/check_storage_permission.dart';

// this gets the files from device
abstract class AudioFilesDataSources {
  Future<List<FileSystemEntity>> getAudioFiles();
}

class AudioFilesDataSourcesImpl implements AudioFilesDataSources {
  List supportedExtensions = ["mp3", "flac", "m4a", "ogg", "opus", "wav"];

  @override
  Future<List<FileSystemEntity>> getAudioFiles() async {
    final CheckStoragePermission permissionAndDirectory =
        CheckStoragePermission();

    final bool isGranted = await permissionAndDirectory.getStoragePermission(); // check permissions

    if (isGranted) {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_MUSIC);
      List<FileSystemEntity> allFiles = [];

      final dir = Directory(path);
      // All files, filtered
      allFiles = dir.listSync(recursive: true, followLinks: false).toList();

      // supported and tested audio codecs with flutter_sound: mp3, flac, m4a, ogg, opus, wav
      // tested: metadata_god supports only mp3 (id3v2.4) and m4a fully. flac, ogg and opus also, provided they were written with supporting software.
      // also exclude .trashed and .thumbnails files, and folders
      Future<List<FileSystemEntity>> audioFiles = Future.value(allFiles
          .where((file) =>
      supportedExtensions
          .contains(basename(file.path).split('.').last.toLowerCase()) ==
          true)
          .where((file) => file.path.contains(".trashed") == false)
          .where((file) => file.path.contains(".thumbnails") == false)
          .where((el) => (el is Directory) == false)
          .toList());
      return Future.value(audioFiles);
    } else {
      return <FileSystemEntity>[];
    }
  }

}
