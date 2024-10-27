import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../globals.dart';

class PlaylistHandler {
  // get the correct m3u file
  Future<File> getFile(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    if (!plDir.existsSync()) {
      await plDir.create();
    }
    return File("${plDir.path}/$fileName.m3u");
  }

  Future<void> reorderLinesInFile(
      String fileName, int oldIndex, int newIndex) async {
    // we get the correct file
    final file = await getFile(fileName);
    // we save lines from file to list
    List<String> lines = await file.readAsLines();

    // we manipulate the list
    String movedLine = lines[oldIndex];
    lines.removeAt(oldIndex);
    lines.insert(newIndex, movedLine);

    // we clear the file
    await file.writeAsString('', mode: FileMode.write);
    // we write lines from list to file
    for (String line in lines) {
      await file.writeAsString('$line\n', mode: FileMode.append);
    }
    //await file.writeAsString(lines.join('\n'), mode: FileMode.write, flush: true);
  }

  Future<void> deleteLineInFile(String fileName, int index) async {
    final file = await getFile(fileName);
    List<String> lines = await file.readAsLines();

    lines.removeAt(index);
    await file.writeAsString('', mode: FileMode.write);
    for (String line in lines) {
      await file.writeAsString('$line\n', mode: FileMode.append);
    }
    //await file.writeAsString(lines.join('\n'), mode: FileMode.write, flush: true);
  }

  Future<void> deleteFile(String fileName) async {
    final file = await getFile(fileName);
    await file.delete();
  }

  Future<bool> createPlaylistFile(List playlist, String name) async {
    try {
      List playlists = [];
      playlists.add([name, playlist]);
      final File file = await getFile(name).then((value) async {
        if (await value.exists()) {
          await value.delete();
        }
        return value.create();
      });
      for (String s in playlist) {
        await file.writeAsString("$s\n", mode: FileMode.append);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // filePath == audio file path
  void writeNewTrackInPlaylistFile(
      String selectedPlaylist, String filePath) async {
    final File file = await getFile(selectedPlaylist);
    file.writeAsString("$filePath\n", mode: FileMode.append, flush: true);
  }
}
