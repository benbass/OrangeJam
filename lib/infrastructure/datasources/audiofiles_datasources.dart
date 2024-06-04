import 'dart:io';
import 'package:path/path.dart';

import '../../services/get_permission_directory.dart';

abstract class AudioFilesDataSources {
  Future<List> getAudioFiles();
}

class AudioFilesDataSourcesImpl implements AudioFilesDataSources{

  @override
  Future<List> getAudioFiles() async {
    final PermissionAndDirectory permissionAndDirectory =
        PermissionAndDirectory();


    String path = "";
    late Future<List> audioFiles;
    List supportedExtensions = ["mp3", "flac", "m4a", "ogg", "opus", "wav"];

    // Befülle Listen
    loadAudioFiles() async {
      List<FileSystemEntity> allFiles = [];

      final dir = Directory(path);
      // Alle files, gefiltert
      allFiles = dir
          .listSync(recursive: true, followLinks: false)
          .toList();

      // supported and tested audio codecs with flutter_sound: mp3, flac, m4a, ogg, opus, wav
      // tested: metadata_god supports only mp3 (id3v2.4) and m4a fully. flac, ogg and opus also, provided they were written with supporting software.
      // also exclude .trashed and .thumbnails files, and folders
      audioFiles = Future.value(allFiles
          .where((file) => supportedExtensions.contains(basename(file.path).split('.').last.toLowerCase()) == true)
          .where((file) => file.path.contains(".trashed") == false)
          .where((file) => file.path.contains(".thumbnails") == false)
          .where((el) => (el is Directory) == false)
          .toList());
    }

    await permissionAndDirectory.getStoragePermission();
    if (permissionAndDirectory.isGranted) {
      path = await permissionAndDirectory.getPublicMusicDirectoryPath();
      await loadAudioFiles();
    }

    return Future.value(audioFiles);

  }
}
