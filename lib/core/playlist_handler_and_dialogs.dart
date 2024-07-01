import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../application/playlists/playlists_bloc.dart';
import '../generated/l10n.dart';
import '../presentation/homepage/custom_widgets/custom_widgets.dart';
import 'globals.dart';

class PlaylistHandler {
  final List playlists;

  PlaylistHandler({required this.playlists});

  String selectedVal = "";
  Map<int, String> playlistMap = {};
  List<String> playlistNames = [];
  int selectedIndex = 0;
  final TextEditingController txtController = TextEditingController();

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

  void buildDropDownStrings() async {
    playlistNames.clear();
    for (var el in playlists) {
      playlistNames.add(el[0]);
    }
    playlistMap = playlistNames.asMap();
  }

  // Dialog, wenn Icon + im Bottomsheet für Playlists getappt wurde
  void createPlaylist(String description, List playlist) {
    txtController.clear();
    final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);
    showDialog(
      context: globalScaffoldKey.scaffoldKey.currentContext!,
      builder: (context) {
        return OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // We prevent a pixel overflow
            Navigator.pop(context);
          }
          if (orientation == Orientation.portrait) {
            return CustomDialog(
              content: MyTextInput(
                txtController: txtController,
                themeData: themeData,
              ),
              actions: [
                SimpleButton(
                  themeData: themeData,
                  btnText: S.of(context).buttonCancel,
                  function: () {
                    Navigator.of(context).pop();
                  },
                ),
                buildButtonSaveNewPlaylist(themeData, playlist),
              ],
              showDropdown: false,
              titleWidget: DescriptionText(
                themeData: themeData,
                description: description,
              ),
              themeData: themeData,
            );
          } else {
            return const SizedBox.shrink();
          }
        });
      },
    );
  }

  // Button Save for a new playlist
  TextButton buildButtonSaveNewPlaylist(ThemeData themeData, List playlist) {
    return TextButton(
      onPressed: () async {
        if (txtController.value.text.isNotEmpty) {
          final String name = txtController.value.text.trim();
          bool nameExists = playlists
              .any((element) => element[0] == name);
          if (!nameExists) {
            playlists.add([name, playlist]);

            final Directory appDir = await getApplicationDocumentsDirectory();
            final Directory plDir =
                Directory("${appDir.path}/${appName}_Playlists");
            if (!plDir.existsSync()) {
              await plDir.create();
            }
            final File file = await File(
                    "${plDir.path}/$name.m3u")
                .create();
            for (String s in playlist) {
              await file.writeAsString("$s\n", mode: FileMode.append);
            }
            Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
            ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
                .showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                  S.of(globalScaffoldKey.scaffoldKey.currentContext!).playlistHandler_thePlaylistNameWasCreated(name),
                ),
              ),
            );
            txtController.clear();
          } else {
            Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
            createPlaylist(
                S.of(globalScaffoldKey.scaffoldKey.currentContext!).playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName(name),
                playlist);
          }
        } else {
          Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
          createPlaylist(S.of(globalScaffoldKey.scaffoldKey.currentContext!).playlistHandler_enterANameForYourNewPlaylist, playlist);
        }
      },
      style: themeData.textButtonTheme.style,
      child: Text(
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).save,
      ),
    );
  }

  // Dialog after tap on slidable action on list item
  Future addToPlaylist(String filePath) async {
    final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);
    String description = S.of(globalScaffoldKey.scaffoldKey.currentContext!).playlistHandler_addThisTrackToPlaylist;
    buildDropDownStrings();

    if (playlists.isNotEmpty) {
      return await showDialog(
        context: globalScaffoldKey.scaffoldKey.currentContext!,
        builder: (context) {
          return CustomDialog(
            titleWidget: DescriptionText(
              themeData: themeData,
              description: description,
            ),
            content: buildDropDownAddToPlaylist(themeData),
            actions: [
              SimpleButton(
                themeData: themeData,
                btnText: S.of(context).buttonCancel,
                function: () {
                  Navigator.of(context).pop();
                },
              ),
              buildButtonAddToPlaylist(filePath, themeData),
            ],
            showDropdown: false,
            themeData: themeData,
          );
        },
      );
    } else {
      return await showDialog(
        context: globalScaffoldKey.scaffoldKey.currentContext!,
        builder: (context) {
          description = S.of(context).playlistHandler_youDontHaveAnyPlaylistYet;
          return CustomDialog(
            content: const SizedBox.shrink(),
            actions: [
              SimpleButton(
                themeData: themeData,
                btnText: S.of(context).buttonOk,
                function: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            showDropdown: false,
            titleWidget:
                DescriptionText(themeData: themeData, description: description),
            themeData: themeData,
          );
        },
      );
    }
  }

  void closeDialogAddToPlaylist() {
    Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
    ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
        .showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(S.of(globalScaffoldKey.scaffoldKey.currentContext!).playlistHandler_theTrackWasAddedToThePlaylistSelectedval(selectedVal)),
      ),
    );
    selectedVal = "";
  }

  // Button Save for adding a track to a playlist
  StatefulBuilder buildButtonAddToPlaylist(
      String filePath, ThemeData themeData) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return TextButton(
        onPressed: () async {
          if (selectedVal != "") {
            if (!playlists[selectedIndex][1].contains(filePath)) {
              final Directory appDir = await getApplicationDocumentsDirectory();
              final Directory plDir =
                  Directory("${appDir.path}/${appName}_Playlists");
              final File file = File("${plDir.path}/$selectedVal.m3u");
              file.writeAsString("$filePath\n",
                  mode: FileMode.append, flush: true);
              playlistsBloc.state.playlists[selectedIndex][1].add(filePath);
              closeDialogAddToPlaylist();
              setState(() {
                // Then we update UI in case we added a track to current playlist (based on current id)
                if (playlistsBloc.state.playlistId != -2) {
                  playlistsBloc
                      .add(PlaylistChanged(id: playlistsBloc.state.playlistId));
                }
              });
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                      S.of(context).playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack(selectedVal)),
                  backgroundColor: themeData.colorScheme.primary,
                ),
              );
            }
          } else {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(S.of(context).playlistHandler_pickAPlaylist),
                backgroundColor: themeData.colorScheme.primary,
              ),
            );
          }
        },
        style: themeData.textButtonTheme.style,
        child: Text(
          S.of(context).save,
        ),
      );
    });
  }

  // Dropdown for playlist names in dialog addToPlaylist()
  StatefulBuilder buildDropDownAddToPlaylist(ThemeData themeData) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 60,
          child: Column(
            children: [
              PopupMenuButton(
                color: themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
                itemBuilder: (context) {
                  return playlistMap.entries.map((entry) {
                    return PopupMenuItem(
                      value: entry.value,
                      child: InkWell(
                        splashColor: themeData.colorScheme.secondary,
                        onTap: () {
                          var selectedKey = playlistMap.keys.firstWhere(
                              (key) => playlistMap[key] == entry.value);
                          setState(() {
                            selectedIndex = selectedKey;
                            selectedVal = entry.value;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.value,
                                style: themeData.textTheme.bodyLarge!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: selectedVal == ""
                          ? Text(S.of(context).playlistHandler_pick)
                          : Text(selectedVal),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
