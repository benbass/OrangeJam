import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orange_player/presentation/homepage/listview/widgets/item_trailing.dart';

import '../../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../core/globals.dart';
import '../../../../core/position_monitoring.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../../../core/audiohandler.dart';
import '../../../../core/playlist_handler_and_dialogs.dart';
import 'item_leading.dart';
import 'item_texts.dart';

class ListItemSlidable extends StatelessWidget {
  const ListItemSlidable({
    super.key,
    required this.index,
    required this.track,
    required this.backgroundColor,
    required this.selectedTrackId,
    required this.audioHandler,
    required this.themeData,
    required this.textColor,
    required this.playlistHandler,
  });

  final int index;
  final TrackEntity track;
  final Color backgroundColor;
  final int selectedTrackId;
  final MyAudioHandler audioHandler;
  final ThemeData themeData;
  final Color textColor;
  final PlaylistHandler playlistHandler;

  @override
  Widget build(BuildContext context) {
    playTrack(TrackEntity track) {
      BlocProvider.of<PlayerControlsBloc>(context)
          .add(TrackItemPressed(track: track));
    }

    final playlistsBloc =
        BlocProvider.of<PlaylistsBloc>(globalScaffoldKey.scaffoldKey.currentContext!);

    void snackBarFileNotExist() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text("Ups, the file '${track.filePath}' was not found!"),
        ),
      );
    }

    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              playlistHandler.addToPlaylist(track.filePath);
            },
            flex: 20,
            backgroundColor: const Color(0xFFFF8100),
            foregroundColor: const Color(0xFF202531),
            icon: Icons.add,
            label: 'Playlist',
            padding: EdgeInsets.zero,
          ),
          SlidableAction(
            onPressed: (_) {
              if (!GlobalLists().queue.contains(track)) {
                playlistsBloc.add(TrackAddedToQueue(track: track));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(
                        "The track '${track.trackName}' is now added to the queue."),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: const Text("The queue already contains this track."),
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
      endActionPane: playlistsBloc.state.playlistId > -2
          ? ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    if (playlistsBloc.state.playlistId > -1) {
                      playlistsBloc
                          .state.playlists[playlistsBloc.state.playlistId][1]
                          .remove(track.filePath);
                      playlistHandler.deleteLineInFile(
                          playlistsBloc.state
                              .playlists[playlistsBloc.state.playlistId][0],
                          index);
                    } else {
                      playlistsBloc.add(TrackRemoveFromQueue(track: track));
                    }
                    playlistsBloc.add(
                        PlaylistChanged(id: playlistsBloc.state.playlistId));
                  },
                  backgroundColor: const Color(0xFFFF8100),
                  foregroundColor: const Color(0xFF202531),
                  icon: Icons.delete,
                  label: 'Remove',
                ),
              ],
            )
          : null,
      child: Card(
        key: ValueKey(track),
        color: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 72.0,
          child: InkWell(
            splashColor: Colors.black87,
            onTap: () async {
              // The Bloc will decide if track is to be played (tap on new track) or stopped (tap on current track)
              if (await File(track.filePath).exists()) {
                playTrack(track);
                // we delay to ensure that trackPositionCubit.state != null
                Future.delayed(const Duration(milliseconds: 200)).whenComplete(() => startPositionMonitoring());

              } else {
                snackBarFileNotExist();
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
                ItemTexts(track: track, themeData: themeData, textColor: textColor),
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


