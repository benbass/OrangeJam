import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orange_player/presentation/homepage/my_listview/widgets/tile_trailing.dart';

import '../../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../../../core/audiohandler.dart';
import '../../../../core/playlist_handler.dart';
import '../../homepage.dart';

class ItemSlidable extends StatelessWidget {
  const ItemSlidable({
    super.key,
    required this.index,
    required this.track,
    required this.backgroundColor,
    required this.selectedTrackId,
    required this.audioHandler,
    required this.themeData,
    required this.textColor,
    required this.startPositionMonitoring,
    required this.playlistHandler,
  });

  final int index;
  final TrackEntity track;
  final Color backgroundColor;
  final int selectedTrackId;
  final MyAudioHandler audioHandler;
  final ThemeData themeData;
  final Color textColor;
  final Function startPositionMonitoring;
  final PlaylistHandler playlistHandler;

  @override
  Widget build(BuildContext context) {
    playTrack(TrackEntity track) {
      BlocProvider.of<PlayerControlsBloc>(context)
          .add(TrackItemPressed(track: track));
    }

    final playlistsBloc =
        BlocProvider.of<PlaylistsBloc>(myGlobals.scaffoldKey.currentContext!);

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
                    //playlistsBloc.state.playlists.removeAt(index);
                    //tracklistBloc.add(TrackListLoadedEvent());
                    if (playlistsBloc.state.playlistId > -1) {
                      playlistsBloc
                          .state.playlists[playlistsBloc.state.playlistId][1]
                          .remove(track.filePath);
                      //playlistHandler.updateDatabase();
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
              // The Bloc will decide if track is to be played or stopped depending on tap on new track or on current track
              if (await File(track.filePath).exists()) {
                playTrack(track);
                // we delay so trackPositionCubit.state != null anymore
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
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(35),
                      child: track.albumArt == null
                          ? const Image(
                              image: AssetImage(
                                "assets/album-placeholder.png",
                              ),
                              fit: BoxFit.fill,
                            )
                          : Image(
                              image: MemoryImage(track.albumArt!),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240,
                          child: Text(
                            track.trackName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: themeData.textTheme.bodyMedium!
                                .copyWith(color: textColor),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            track.trackArtistNames ?? "",
                            style: themeData.textTheme.bodySmall!
                                .copyWith(color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 66,
                  child: TileTrailing(
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
