import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/core/player/audiohandler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../../application/listview/ui/is_scrolling_cubit.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../core/playlists/playlist_handler.dart';
import 'widgets/list_item_slidable.dart';

class MyListview extends StatelessWidget {
  final List<TrackEntity> tracks;
  final ScrollController sctr;
  final ListObserverController observController;
  final IsScrollingCubit isScrollingCubit;
  final IsScrollReverseCubit isScrollReverseCubit;
  final MyAudioHandler audioHandler;
  final PlaylistHandler playlistHandler;

  const MyListview({
    super.key,
    required this.tracks,
    required this.sctr,
    required this.observController,
    required this.isScrollingCubit,
    required this.isScrollReverseCubit,
    required this.audioHandler,
    required this.playlistHandler,
  });

  @override
  Widget build(BuildContext context) {
    final trackPositionCubit = BlocProvider.of<TrackPositionCubit>(context);
    final trackDurationCubit = BlocProvider.of<TrackDurationCubit>(context);
    BlocProvider.of<PlayerControlsBloc>(context);

    final themeData = Theme.of(context);

    int selectedTrackId = 0;

    void onScrollEvent() {
      if (sctr.position.userScrollDirection == ScrollDirection.idle) {
        isScrollingCubit.setIsScrolling(false);
      }
      if (sctr.position.userScrollDirection == ScrollDirection.forward) {
        isScrollReverseCubit.setIsScrollReverse(false);
        isScrollingCubit.setIsScrolling(true);
      } else if (sctr.position.userScrollDirection == ScrollDirection.reverse) {
        isScrollReverseCubit.setIsScrollReverse(true);
        isScrollingCubit.setIsScrolling(true);
      }
    }

    sctr.addListener(onScrollEvent);

    // Update progressbar and handle behaviour when track is completed
    audioHandler.flutterSoundPlayer.onProgress?.listen((event) {
      trackDurationCubit.setDuration(event.duration);
      trackPositionCubit.setPosition(event.position);
    });

    return Builder(builder: (context) {
      final playerControlsState = context.watch<PlayerControlsBloc>().state;
      final playlistsState = context.watch<PlaylistsBloc>().state;
      return ListViewObserver(
        controller: observController,
        child: ReorderableListView.builder(
            shrinkWrap: true,
            itemExtent: 73,
            scrollController: sctr,
            physics: const BouncingScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              TrackEntity track = tracks[oldIndex];
              tracks.removeAt(oldIndex); // Update UI
              tracks.insert(newIndex, track);
              // If this is a playlist, we save new order
              if (playlistsState.playlistId > -1) {
                playlistsState.playlists[playlistsState.playlistId][1]
                    .remove(track.filePath);
                playlistsState.playlists[playlistsState.playlistId][1]
                    .insert(newIndex, track.filePath);
                //playlistHandler.updateDatabase();
                playlistHandler.reorderLinesInFile(
                    playlistsState.playlists[playlistsState.playlistId][0],
                    oldIndex,
                    newIndex);
              }
            },
            footer: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
                      builder: (context, state) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: state.height == 200 ? 200 : 0,
                    );
                  });
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            itemCount: tracks.length,
            itemBuilder: (BuildContext context, int index) {
              final TrackEntity track = tracks[index];
              selectedTrackId = playerControlsState.track.id;

              final backgroundColor = selectedTrackId != track.id
                  ? index % 2 == 0
                      ? const Color(0xFF181C25)
                      : const Color(0xFF101319)
                  : const Color(0xFFFF8100);

              final textColor = selectedTrackId != track.id
                  ? const Color(0xFFCBD4C2)
                  : const Color(0xFF202531);

              return ListItemSlidable(
                key: Key(index.toString()),
                index: index,
                track: track,
                backgroundColor: backgroundColor,
                selectedTrackId: selectedTrackId,
                audioHandler: audioHandler,
                themeData: themeData,
                textColor: textColor,
                playlistHandler: playlistHandler,
              );
            }),
      );
    });
  }
}
