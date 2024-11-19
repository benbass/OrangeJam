import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orangejam/presentation/homepage/listview/widgets/item_trailing.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../core/globals.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../../../core/playlists/playlist_handler.dart';
import '../../../../generated/l10n.dart';
import '../../dialogs/dialogs.dart';
import '../../dialogs/writer_view.dart';
import 'item_leading.dart';
import 'item_texts.dart';

class ListItemSlidable extends StatelessWidget {
  const ListItemSlidable({
    super.key,
    required this.index,
    required this.track,
    required this.backgroundColor,
    required this.selectedTrackId,
    required this.textColor,
  });

  final int index;
  final TrackEntity track;
  final Color backgroundColor;
  final int selectedTrackId;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(
        context);

    void playTrack(TrackEntity track) {
      BlocProvider.of<PlayerControlsBloc>(context)
          .add(TrackItemPressed(track: track));
    }

    void snackBarFileNotExist() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(S
              .of(context)
              .listItemSlidable_upsTheFileTrackfilepathWasNotFound(
                  track.filePath)),
        ),
      );
    }

    Future<bool> permissionGranted() async {
      if(Platform.isAndroid){
        late bool granted;
        if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
          granted = await Permission.storage.isGranted;
        } else {
          granted = await Permission.audio.isGranted;
        }
        return granted;
      } else {
        return true;
      }
    }

    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            /// Add track to playlist
            onPressed: (_) {
              dialogAddTrackToPlaylist(track.filePath, context);
            },
            flex: 20,
            backgroundColor: const Color(0xFFFF8100),
            foregroundColor: const Color(0xFF202531),
            icon: Icons.add,
            label: 'Playlist',
            padding: EdgeInsets.zero,
          ),

          /// Add track to queue
          SlidableAction(
            onPressed: (_) {
              if (!playlistsBloc.state.queue.contains(track)) {
                playlistsBloc.add(TrackAddedToQueue(track: track));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(S
                        .of(context)
                        .listItemSlidable_theTrackTracktracknameIsNowAddedToTheQueue(
                            track.trackName!)),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(S
                        .of(context)
                        .listItemSlidable_theQueueAlreadyContainsThisTrack),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
            flex: 20,
            backgroundColor: const Color(0xFF202531),
            foregroundColor: const Color(0xFFFF8100),
            icon: Icons.queue,
            label: 'Queue',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            /// Edit tags
            onPressed: (_) {
              showDialog(
                builder: (context) => WriterView(
                  track: track,
                ),
                context: context,
              );
            },
            flex: 20,
            backgroundColor: const Color(0xFFFF8100),
            foregroundColor: const Color(0xFF202531),
            icon: Icons.edit,
            label: 'Tags',
            padding: EdgeInsets.zero,
          ),

          /// Remove track from playlist (not available on "Files" view (when playlistId == -2)
          if (playlistsBloc.state.playlistId > -2)
            SlidableAction(
              onPressed: (_) {
                if (playlistsBloc.state.playlistId > -1) {
                  playlistsBloc
                      .state.playlists[playlistsBloc.state.playlistId][1]
                      .remove(track.filePath);
                  PlaylistHandler().deleteLineInFile(
                      playlistsBloc
                          .state.playlists[playlistsBloc.state.playlistId][0],
                      index);
                  playlistsBloc
                      .add(PlaylistChanged(id: playlistsBloc.state.playlistId));
                } else {
                  playlistsBloc.add(TrackRemoveFromQueue(track: track));

                  /// TrackRemoveFromQueue calls PlaylistChanged with id -1
                }
              },
              flex: 20,
              backgroundColor: const Color(0xFF202531),
              foregroundColor: const Color(0xFFFF8100),
              icon: Icons.delete,
              label: S.of(context).listItemSlidable_remove,
            ),
        ],
      ),
      child: Card(
        key: ValueKey(track),
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 74.0,
          child: InkWell(
            splashColor: Colors.black87,
            onTap: () async {
              String filePath = "";
              if(Platform.isAndroid){
                filePath = track.filePath;
                // The Bloc will decide if track is to be played (tap on new track) or stopped (tap on current track)
                // We check first if file still exists and storage permission is still granted
                if (await File(filePath).exists() && await permissionGranted()) {
                  playTrack(track);
                } else {
                  snackBarFileNotExist();
                }
              } else {
                playTrack(track);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: ItemLeading(track: track),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                ItemTexts(track: track, textColor: textColor),
                SizedBox(
                  height: 66,
                  child: ItemTrailing(
                    id: track.id,
                    currentId: selectedTrackId,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
