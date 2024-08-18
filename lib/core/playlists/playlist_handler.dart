import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../generated/l10n.dart';
import '../../presentation/homepage/dialogs/dialogs.dart';
import '../globals.dart';

class PlaylistHandler {
  final List playlists;

  PlaylistHandler({required this.playlists});

  // get the correct m3u file
  Future<File> getFile(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    if (!plDir.existsSync()) {
      await plDir.create();
    }
    return File("${plDir.path}/$fileName.m3u");
  }

  // this method is used in dialog dialogAddTrackToPlaylist() for the dropdown menu. And in homepage where the strings are needed for the playlists menu
  void buildPlaylistStrings() async {
    PlaylistsNamesAndSelectedVars().playlistNames.clear();
    for (var el in playlists) {
      PlaylistsNamesAndSelectedVars().playlistNames.add(el[0]);
    }
    PlaylistsNamesAndSelectedVars().playlistMap =
        PlaylistsNamesAndSelectedVars().playlistNames.asMap();
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

  Future<void> createPlaylistFile(List playlist) async {
    if (PlaylistsNamesAndSelectedVars().txtController.value.text.isNotEmpty) {
      final String name =
          PlaylistsNamesAndSelectedVars().txtController.value.text.trim();
      bool nameExists = playlists.any((element) => element[0] == name);
      if (!nameExists) {
        playlists.add([name, playlist]);

        final File file = await getFile(name).then((value) => value.create());

        for (String s in playlist) {
          await file.writeAsString("$s\n", mode: FileMode.append);
        }

        Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
        ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
            .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            content: Text(
              S
                  .of(globalScaffoldKey.scaffoldKey.currentContext!)
                  .playlistHandler_thePlaylistNameWasCreated(name),
            ),
          ),
        );
        PlaylistsNamesAndSelectedVars().txtController.clear();
      } else {
        Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
        dialogCreatePlaylist(
          S
              .of(globalScaffoldKey.scaffoldKey.currentContext!)
              .playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName(
                  name),
          playlist,
          this,
        );
      }
    } else {
      Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
      dialogCreatePlaylist(
        S
            .of(globalScaffoldKey.scaffoldKey.currentContext!)
            .playlistHandler_enterANameForYourNewPlaylist,
        playlist,
        this,
      );
    }
  }

  // filePath == audio file path
  void writeNewTrackInPlaylistFile(
      String selectedPlaylist, String filePath) async {
    final File file = await getFile(selectedPlaylist);
    file.writeAsString("$filePath\n", mode: FileMode.append, flush: true);
  }
}
