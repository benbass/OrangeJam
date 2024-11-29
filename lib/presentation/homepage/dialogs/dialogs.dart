import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../application/playlists/selected_playlist_name_cubit.dart';
import '../../../core/globals.dart';
import '../../../core/playlists/backup_playlists.dart';
import '../../../core/playlists/playlist_handler.dart';
import '../../../core/playlists/restore_playlists.dart';
import '../../../generated/l10n.dart';
import '../custom_widgets/custom_widgets.dart';

/// a simple dialog for canceling actions at backup and restore of playlists
void dialogClose(BuildContext context, String message) {
  showDialog(
    builder: (context) => CustomDialog(
      content: const SizedBox.shrink(),
      actions: [
        SimpleButton(
          btnText: S.of(context).close,
          function: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      showDropdown: false,
      titleWidget: DescriptionText(
        description: message,
      ),
    ),
    context: context,
  );
}

/// END simple dialog for canceling actions

/// This dialog is called when user taps on one of the buttons restore or backup in drawer
void dialogActionRestoreOrBackupPlaylists(
    BuildContext context, String restoreOrBackup) {
  String playlistsWillBeDeleted =
      S.of(context).cutomWidgets_pickTheZipFileThatContainsYourBackup(appName);
  String zipWillBeCreated = Platform.isAndroid
      ? S.of(context).cutomWidgets_aZipArchiveWillBeCreatedAndUploaded
      : S.of(context).cutomWidgets_aZipArchiveWillBeCreatedAndSaved;
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
          btnText: abort,
          function: () => Navigator.pop(context, false),
        ),
        SimpleButton(
          btnText: continu,
          function: () => Navigator.pop(context, true),
        ),
      ],
      showDropdown: false,
      titleWidget: DescriptionText(
        description: restoreOrBackup == "restore" ? restore : backup,
      ),
    ),
    context: context,
  ).then((exit) {
    if (exit == null) return;
    if (exit) {
      if (context.mounted) {
        restoreOrBackup == "restore"
            ? restoreM3uFiles(context)
            : backupM3uFiles(context);
      }
    } else {
      return;
    }
  });
}

/// END dialog restore or backup

/// DIALOG addToPlaylist() (add a track to an existing playlist)
// Dropdown for playlist names in dialog addToPlaylist()
StatefulBuilder dropDownMenuAddToPlaylist() {
  String selectedPlaylist = "";
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      List<String> playlistNames = [];
      for (var p in BlocProvider.of<PlaylistsBloc>(context).state.playlists) {
        playlistNames.add(p[0]);
      }
      return SizedBox(
        height: 60,
        child: Column(
          children: [
            PopupMenuButton(
              color: Theme.of(context)
                  .dialogTheme
                  .backgroundColor!
                  .withOpacity(0.9),
              itemBuilder: (context) {
                return playlistNames.map((entry) {
                  return PopupMenuItem(
                    child: InkWell(
                      splashColor: Theme.of(context).colorScheme.secondary,
                      onTap: () {
                        setState(() {
                          selectedPlaylist = entry;
                        });
                        BlocProvider.of<SelectedPlaylistNameCubit>(context)
                            .setName(entry);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry,
                              style: Theme.of(context).textTheme.bodyLarge!,
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
                    child: selectedPlaylist.isEmpty
                        ? Text(S.of(context).playlistHandler_pick)
                        : Text(selectedPlaylist),
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
StatefulBuilder buttonSaveAddTrackToPlaylist(String filePath) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    return TextButton(
      onPressed: () async {
        if (BlocProvider.of<SelectedPlaylistNameCubit>(context)
            .state
            .isNotEmpty) {
          String selectedPlaylist =
              BlocProvider.of<SelectedPlaylistNameCubit>(context).state;
          int index = playlistsBloc.state.playlists
              .indexWhere((p) => p[0] == selectedPlaylist);
          if (!playlistsBloc.state.playlists[index][1].contains(filePath)) {
            // we update the m3u file
            PlaylistHandler()
                .writeNewTrackInPlaylistFile(selectedPlaylist, filePath);
            // we update the selected playlist in bloc
            playlistsBloc.state.playlists[index][1].add(filePath);
            // track is now added to selected playlist: we close the dialog an inform user about success
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(S
                    .of(context)
                    .playlistHandler_theTrackWasAddedToThePlaylistSelectedval(
                        selectedPlaylist)),
              ),
            );
            BlocProvider.of<SelectedPlaylistNameCubit>(context).setName("");
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
                        selectedPlaylist)),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(S.of(context).playlistHandler_pickAPlaylist),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      },
      style: Theme.of(context).textButtonTheme.style,
      child: Text(
        S.of(context).save,
      ),
    );
  });
}

// Dialog after tap on slidable action on list item
Future dialogAddTrackToPlaylist(String filePath, BuildContext context) async {
  final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
  String description = S.of(context).playlistHandler_addThisTrackToPlaylist;

  if (playlistsBloc.state.playlists.isNotEmpty) {
    return await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          titleWidget: DescriptionText(
            description: description,
          ),
          content: dropDownMenuAddToPlaylist(),
          actions: [
            SimpleButton(
              btnText: S.of(context).buttonCancel,
              function: () {
                Navigator.of(context).pop();
              },
            ),
            buttonSaveAddTrackToPlaylist(filePath),
          ],
          showDropdown: false,
        );
      },
    );
  } else {
    return await showDialog(
      context: context,
      builder: (context) {
        description = S.of(context).playlistHandler_youDontHaveAnyPlaylistYet;
        return CustomDialog(
          content: const SizedBox.shrink(),
          actions: [
            SimpleButton(
              btnText: S.of(context).buttonOk,
              function: () {
                Navigator.of(context).pop();
              },
            )
          ],
          showDropdown: false,
          titleWidget: DescriptionText(description: description),
        );
      },
    );
  }
}

/// END DIALOG addToPlaylist()

/// Dialog for Icon + in BottomSheet for Playlists (create a new playlist) AND for saving queue as new playlist
void dialogCreatePlaylist(
    String description, List playlist, BuildContext context) {
  final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
  TextEditingController txtController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return CustomDialog(
        content: MyTextInput(
          txtController: txtController,
        ),
        actions: [
          SimpleButton(
            btnText: S.of(context).buttonCancel,
            function: () {
              Navigator.of(context).pop();
            },
          ),
          SimpleButton(
            btnText: S.of(context).save,
            function: () async {
              String name = txtController.text.trim();
              bool nameExists = playlistsBloc.state.playlists
                  .any((element) => element[0] == name);
              if (name.isNotEmpty && !nameExists) {
                // we create file
                bool success =
                    await PlaylistHandler().createPlaylistFile(playlist, name);
                if (success) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          S
                              .of(context)
                              .playlistHandler_thePlaylistNameWasCreated(name),
                        ),
                      ),
                    );
                  }
                  // we send event
                  playlistsBloc
                      .add(PlaylistCreated(name: name, playlist: playlist));
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          S.of(context).edit_tags_snackBarUpdateError,
                        ),
                      ),
                    );
                  }
                }
              } else if (nameExists) {
                Navigator.of(context).pop();
                dialogCreatePlaylist(
                  S
                      .of(context)
                      .playlistHandler_thePlaylistNameAlreadyExistsnpleaseChooseAnotherName(
                          name),
                  playlist,
                  context,
                );
              } else if (name.isEmpty) {
                Navigator.of(context).pop();
                dialogCreatePlaylist(
                  S.of(context).playlistHandler_enterANameForYourNewPlaylist,
                  playlist,
                  context,
                );
              }
            },
          )
        ],
        showDropdown: false,
        titleWidget: DescriptionText(
          description: description,
        ),
      );
    },
  );
}

/// END Dialog for Icon + in BottomSheet for Playlists
