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
    late File audioFile;

    if (files.isNotEmpty) {
      for (File m3uFile in files) {
        final lines = await m3uFile.readAsLines();
        final List linesList = [];
        bool rewrite = false;
        for (String line in lines) { // a line is a path of an audio file
          // we exclude Extended m3u headers, comments and empty lines
          // (User may try to import unsupported extended m3u files)
          if(!line.startsWith('#') || line.isNotEmpty) {
            audioFile = File(line);
          }

          bool exists = false;
          if(Platform.isIOS){
            exists = await platform.invokeMethod('fileExists', {'assetUrl': audioFile.path});
          } else {
            exists = await audioFile.exists(); // we check if file still exists
          }

          if (exists) {
            linesList.add(line); // only if file exists, its path is added to linesList
          } else {
            // if not, we don't want to keep this path in file so we will update the file
            rewrite = true;
          }
        }

        // We re-write the m3u file with fresh linesList when at least one audio file does not exist anymore
        if(rewrite == true){
          // we clear the file content
          await m3uFile.writeAsString('', mode: FileMode.write);
          for (String line in linesList) {
            // we write each line to file
            await m3uFile.writeAsString('$line\n', mode: FileMode.append);
          }
        }

        /// We create a list of lists of string, list as:
        /*
        [
         [Playlist name1, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         [Playlist name2, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         [Playlist name3, [/path/to/Song1, /path/to/Song2, /path/to/Song3 ...]],
         ]
    */
        list.add([basenameWithoutExtension(m3uFile.path), linesList]);
      }
    }
    return list;
  }
}
