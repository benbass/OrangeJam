import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/globals.dart';

abstract class Playlistsdatasource {
  Future<List> getPlaylistsFromM3uFiles();
}

class PlaylistsDatasourceImpl implements Playlistsdatasource {
  @override
  Future<List> getPlaylistsFromM3uFiles() async {
    List list = [];

    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    if (!plDir.existsSync()) {
      await plDir.create();
    }
    List files = plDir.listSync();

    if (files.isNotEmpty) {
      for (File file in files) {
        final lines = await file.readAsLines();
        List linesList = [];
        for (String line in lines) {
          linesList.add(line);
        }
        // We create a list of string, list as:
    /*
        [
         [Playlist name1, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         [Playlist name2, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         [Playlist name3, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         ]
    */
        list.add([basenameWithoutExtension(file.path), linesList]);
      }
    }
    return list;
  }
}
