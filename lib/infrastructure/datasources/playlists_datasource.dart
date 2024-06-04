import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class Playlistsdatasource {
  Future<List> getPlaylistsFromM3uFiles();
}

class PlaylistsDatasourceImpl implements Playlistsdatasource {
  @override
  Future<List> getPlaylistsFromM3uFiles() async {
    List list = [];

    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/Orange_Playlists");
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
        list.add([basenameWithoutExtension(file.path), linesList]);
      }
    }
    return list;
  }
}
