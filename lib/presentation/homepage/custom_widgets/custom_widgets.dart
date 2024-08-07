import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/core/playlists/playlist_handler.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../core/globals.dart';
import 'package:orange_player/core/playlists/backup_restore_playlists.dart';

import '../../../generated/l10n.dart';

/// This is the main dialog widget:
class CustomDialog extends StatelessWidget {
  final Widget content;
  final List<Widget> actions;
  final bool showDropdown;
  final Widget titleWidget;
  final ThemeData themeData;

  const CustomDialog({
    super.key,
    required this.content,
    required this.actions,
    required this.showDropdown,
    required this.titleWidget,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    // BackdropFilter: creates a blur behinds the child (iOS like)
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        title: titleWidget,
        backgroundColor:
            themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              if (showDropdown) const Placeholder() // DropDown?
            ],
          ),
        ),
        actions: actions,
      ),
    );
  }
}

/// This is the dialog title
class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
    required this.themeData,
    required this.description,
  });

  final ThemeData themeData;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: themeData.dialogTheme.titleTextStyle,
    );
  }
}

// this function just opens a dialog with a message and a button "Close"
void dialogClose(BuildContext context, message) {
  final themeData = Theme.of(context);
  showDialog(
    builder: (context) => CustomDialog(
      content: const SizedBox.shrink(),
      actions: [
        SimpleButton(
          themeData: themeData,
          btnText: S.of(context).close,
          function: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      showDropdown: false,
      titleWidget: DescriptionText(
        themeData: themeData,
        description: message,
      ),
      themeData: themeData,
    ),
    context: context,
  );
}

void dialogActionRestoreOrBackupPlaylists(
    BuildContext context, String restoreOrBackup) {
  final themeData = Theme.of(context);
  BackupRestorePlaylists backupRestorePlaylists = BackupRestorePlaylists();
  String playlistsWillBeDeleted =
      S.of(context).cutomWidgets_pickTheZipFileThatContainsYourBackup(appName);
  String zipWillBeCreated =
      S.of(context).cutomWidgets_aZipArchiveWillBeCreatedAndUploaded;
  String abort = S.of(context).buttonCancel;
  String continu = S.of(context).buttonContinue;
  String restore = S.of(context).buttonRestore;
  String backup = S.of(context).buttonBackup;
  showDialog(
    builder: (context) => CustomDialog(
      content: restoreOrBackup == "restore"
          ? Text(playlistsWillBeDeleted)
          : Text(zipWillBeCreated),
      actions: <Widget>[
        TextButton(
          style: themeData.textButtonTheme.style,
          child: Text(
            abort,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          style: themeData.textButtonTheme.style,
          child: Text(
            continu,
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
      showDropdown: false,
      titleWidget: DescriptionText(
        themeData: themeData,
        description: restoreOrBackup == "restore" ? restore : backup,
      ),
      themeData: themeData,
    ),
    context: context,
  ).then((exit) {
    if (exit == null) return;
    if (exit) {
      restoreOrBackup == "restore"
          ? backupRestorePlaylists.restoreFiles()
          : backupRestorePlaylists.backupFiles();
    } else {
      return;
    }
  });
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.themeData,
    required this.btnText,
    required this.function,
  });

  final ThemeData themeData;
  final String btnText;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: themeData.textButtonTheme.style,
      child: Text(
        btnText,
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.txtController,
    required this.themeData,
  });

  final TextEditingController txtController;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtController,
      autofocus: true,
      cursorColor: Colors.white54,
      decoration: const InputDecoration(
        focusColor: Colors.white54,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
      ),
      style: themeData.textTheme.bodyLarge!,
    );
  }
}

void buildPlaylistStringsForDropDownMenu(
    PlaylistHandler playlistHandler) async {
  ValuesForPlaylistDialogs().playlistNames.clear();
  for (var el in playlistHandler.playlists) {
    ValuesForPlaylistDialogs().playlistNames.add(el[0]);
  }
  ValuesForPlaylistDialogs().playlistMap =
      ValuesForPlaylistDialogs().playlistNames.asMap();
}

// Dialog after tap on slidable action on list item
Future dialogAddTrackToPlaylist(
    String filePath, PlaylistHandler playlistHandler) async {
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);
  String description = S
      .of(globalScaffoldKey.scaffoldKey.currentContext!)
      .playlistHandler_addThisTrackToPlaylist;
  ValuesForPlaylistDialogs().selectedVal = "";
  buildPlaylistStringsForDropDownMenu(playlistHandler);

  if (playlistHandler.playlists.isNotEmpty) {
    return await showDialog(
      context: globalScaffoldKey.scaffoldKey.currentContext!,
      builder: (context) {
        return CustomDialog(
          titleWidget: DescriptionText(
            themeData: themeData,
            description: description,
          ),
          content: dropDownMenuAddToPlaylist(themeData),
          actions: [
            SimpleButton(
              themeData: themeData,
              btnText: S.of(context).buttonCancel,
              function: () {
                Navigator.of(context).pop();
              },
            ),
            buttonSaveAddTrackToPlaylist(filePath, themeData, playlistHandler),
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

// Dropdown for playlist names in dialog addToPlaylist()
StatefulBuilder dropDownMenuAddToPlaylist(ThemeData themeData) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
        height: 60,
        child: Column(
          children: [
            PopupMenuButton(
              color: themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
              itemBuilder: (context) {
                return ValuesForPlaylistDialogs()
                    .playlistMap
                    .entries
                    .map((entry) {
                  return PopupMenuItem(
                    value:  entry.value,
                    child: InkWell(
                      splashColor: themeData.colorScheme.secondary,
                      onTap: () {
                        var selectedKey = ValuesForPlaylistDialogs()
                            .playlistMap
                            .keys
                            .firstWhere((key) =>
                                ValuesForPlaylistDialogs().playlistMap[key] ==
                                entry.value);
                        setState(() {
                          ValuesForPlaylistDialogs().selectedIndex =
                              selectedKey;
                          ValuesForPlaylistDialogs().selectedVal = entry.value;
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
                    child: ValuesForPlaylistDialogs().selectedVal == ""
                        ? Text(S.of(context).playlistHandler_pick)
                        : Text(ValuesForPlaylistDialogs().selectedVal),
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

// Dialog for Icon + in Bottomsheet for Playlists
void dialogCreatePlaylist(
    String description, List playlist, PlaylistHandler playlistHandler) {
  ValuesForPlaylistDialogs().txtController.clear();
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
              txtController: ValuesForPlaylistDialogs().txtController,
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
              buttonSaveNewPlaylist(themeData, playlist, playlistHandler),
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
TextButton buttonSaveNewPlaylist(
    ThemeData themeData, List playlist, PlaylistHandler playlistHandler) {
  return TextButton(
    onPressed: () async {
      await playlistHandler.createPlaylistFile(playlist);
    },
    style: themeData.textButtonTheme.style,
    child: Text(
      S.of(globalScaffoldKey.scaffoldKey.currentContext!).save,
    ),
  );
}

void closeDialogAddToPlaylist() {
  Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
  ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
      .showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(S
          .of(globalScaffoldKey.scaffoldKey.currentContext!)
          .playlistHandler_theTrackWasAddedToThePlaylistSelectedval(
              ValuesForPlaylistDialogs().selectedVal)),
    ),
  );
  ValuesForPlaylistDialogs().selectedVal = "";
}

// Button Save for adding a track to a playlist
StatefulBuilder buttonSaveAddTrackToPlaylist(
    String filePath, ThemeData themeData, PlaylistHandler playlistHandler) {
  final playlistsBloc = BlocProvider.of<PlaylistsBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextButton(
      onPressed: () async {
        if (ValuesForPlaylistDialogs().selectedVal != "") {
          String selectedPlaylist = ValuesForPlaylistDialogs().selectedVal;
          if (!playlistHandler
              .playlists[ValuesForPlaylistDialogs().selectedIndex][1]
              .contains(filePath)) {
            playlistHandler.writeNewTrackInPlaylistFile(
                selectedPlaylist, filePath);
            playlistsBloc
                .state.playlists[ValuesForPlaylistDialogs().selectedIndex][1]
                .add(filePath);
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
                content: Text(S
                    .of(context)
                    .playlistHandler_thePlaylistSelectedvalAlreadyContainsThisTrack(
                        ValuesForPlaylistDialogs().selectedVal)),
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
