import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../generated/l10n.dart';
import '../../presentation/homepage/custom_widgets/custom_widgets.dart';
import '../globals.dart';

class PlaylistHandler {
  final List playlists;

  PlaylistHandler({required this.playlists});

  Future<void> reorderLinesInFile(
      String fileName, int oldIndex, int newIndex) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    final file = File("${plDir.path}/$fileName.m3u");
    List<String> lines = await file.readAsLines();

    String movedLine = lines[oldIndex];
    lines.removeAt(oldIndex);
    lines.insert(newIndex, movedLine);
    await file.writeAsString('', mode: FileMode.write);
    for (String line in lines) {
      await file.writeAsString('$line\n', mode: FileMode.append);
    }
    //await file.writeAsString(lines.join('\n'), mode: FileMode.write, flush: true);
  }

  Future<void> deleteLineInFile(String fileName, int index) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    final file = File("${plDir.path}/$fileName.m3u");
    List<String> lines = await file.readAsLines();

    lines.removeAt(index);
    await file.writeAsString('', mode: FileMode.write);
    for (String line in lines) {
      await file.writeAsString('$line\n', mode: FileMode.append);
    }
    //await file.writeAsString(lines.join('\n'), mode: FileMode.write, flush: true);
  }

  Future<void> deleteFile(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    final file = File("${plDir.path}/$fileName.m3u");
    await file.delete();
  }

  Future<void> createPlaylistFile(List playlist) async {
    if (ValuesForPlaylistDialogs().txtController.value.text.isNotEmpty) {
      final String name =
          ValuesForPlaylistDialogs().txtController.value.text.trim();
      bool nameExists = playlists.any((element) => element[0] == name);
      if (!nameExists) {
        playlists.add([name, playlist]);

        final Directory appDir = await getApplicationDocumentsDirectory();
        final Directory plDir =
            Directory("${appDir.path}/${appName}_Playlists");
        if (!plDir.existsSync()) {
          await plDir.create();
        }
        final File file = await File("${plDir.path}/$name.m3u").create();
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
        ValuesForPlaylistDialogs().txtController.clear();
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

  void writeNewTrackInPlaylistFile(
      String selectedPlaylist, String filePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory plDir = Directory("${appDir.path}/${appName}_Playlists");
    final File file = File("${plDir.path}/$selectedPlaylist.m3u");
    file.writeAsString("$filePath\n", mode: FileMode.append, flush: true);
  }
}
