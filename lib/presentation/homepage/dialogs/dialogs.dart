import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../core/globals.dart';
import '../../../core/playlists/backup_restore_playlists.dart';
import '../../../core/playlists/playlist_handler.dart';
import '../../../generated/l10n.dart';
import '../custom_widgets/custom_widgets.dart';

/// TODO: implement a file picker instead of saving backups directly to Google Drive

/// a simple dialog for canceling actions (used only in file lib/core/playlists/backup_restore_playlists.dart)
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
/// END simple dialog for canceling actions

/// This dialog is called when user taps on one of the buttons restore or backup in drawer
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
        SimpleButton(
          themeData: themeData,
          btnText: abort,
          function: () => Navigator.pop(context, false),
        ),
        SimpleButton(
          themeData: themeData,
          btnText: continu,
          function: () => Navigator.pop(context, true),
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
/// END dialog restore or backup

/// DIALOG addToPlaylist() (add a track to an existing playlist)
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
                // the entries are saved in a global var by
                return PlaylistsNamesAndSelectedVars()
                    .playlistMap
                    .entries
                    .map((entry) {
                  return PopupMenuItem(
                    value:  entry.value,
                    child: InkWell(
                      splashColor: themeData.colorScheme.secondary,
                      onTap: () {
                        var selectedKey = PlaylistsNamesAndSelectedVars()
                            .playlistMap
                            .keys
                            .firstWhere((key) =>
                        PlaylistsNamesAndSelectedVars().playlistMap[key] ==
                            entry.value);
                        setState(() {
                          // update displayed value after onTap on selected value
                          PlaylistsNamesAndSelectedVars().selectedIndex =
                              selectedKey;
                          PlaylistsNamesAndSelectedVars().selectedVal = entry.value;
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
                    child: PlaylistsNamesAndSelectedVars().selectedVal == ""
                        ? Text(S.of(context).playlistHandler_pick)
                        : Text(PlaylistsNamesAndSelectedVars().selectedVal),
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

// Button Save for adding a track to a playlist
StatefulBuilder buttonSaveAddTrackToPlaylist(
    String filePath, ThemeData themeData, PlaylistHandler playlistHandler) {
  final playlistsBloc = BlocProvider.of<PlaylistsBloc>(
      globalScaffoldKey.scaffoldKey.currentContext!);
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextButton(
      onPressed: () async {
        if (PlaylistsNamesAndSelectedVars().selectedVal != "") {
          String selectedPlaylist = PlaylistsNamesAndSelectedVars().selectedVal;
          if (!playlistHandler
              .playlists[PlaylistsNamesAndSelectedVars().selectedIndex][1]
              .contains(filePath)) {
            // we update the m3u file
            playlistHandler.writeNewTrackInPlaylistFile(
                selectedPlaylist, filePath);
            // we update the selected playlist in bloc
            playlistsBloc
                .state.playlists[PlaylistsNamesAndSelectedVars().selectedIndex][1]
                .add(filePath);
            // track is now added to selected playlist: we close the dialog an inform user about success
            Navigator.of(globalScaffoldKey.scaffoldKey.currentContext!).pop();
            ScaffoldMessenger.of(globalScaffoldKey.scaffoldKey.currentContext!)
                .showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(S
                    .of(globalScaffoldKey.scaffoldKey.currentContext!)
                    .playlistHandler_theTrackWasAddedToThePlaylistSelectedval(
                    PlaylistsNamesAndSelectedVars().selectedVal)),
              ),
            );
            PlaylistsNamesAndSelectedVars().selectedVal = "";
            setState(() {
              // Then we update UI in case we added a track to current playlist (based on current id)
              // this case cannot occur in current app version since we do not allow (for now) user to add same track to a playlist again
              // see above: if (!playlistHandler
              //               .playlists[ValuesForPlaylistDialogs().selectedIndex][1]
              //               .contains(filePath))
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
                    PlaylistsNamesAndSelectedVars().selectedVal)),
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

// Dialog after tap on slidable action on list item
Future dialogAddTrackToPlaylist(
    String filePath, PlaylistHandler playlistHandler) async {
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);
  String description = S
      .of(globalScaffoldKey.scaffoldKey.currentContext!)
      .playlistHandler_addThisTrackToPlaylist;
  PlaylistsNamesAndSelectedVars().selectedVal = "";
  playlistHandler.buildPlaylistStrings();

  if (PlaylistsNamesAndSelectedVars().playlistNames.isNotEmpty) {
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
/// END DIALOG addToPlaylist()

/// Dialog for Icon + in BottomSheet for Playlists (create a new playlist)
void dialogCreatePlaylist(
    String description, List playlist, PlaylistHandler playlistHandler) {
  PlaylistsNamesAndSelectedVars().txtController.clear();
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
              txtController: PlaylistsNamesAndSelectedVars().txtController,
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
              SimpleButton(
                themeData: themeData,
                btnText: S.of(globalScaffoldKey.scaffoldKey.currentContext!).save,
                function: () async {
                  await playlistHandler.createPlaylistFile(playlist);
                },
              )
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
/// END Dialog for Icon + in BottomSheet for Playlists