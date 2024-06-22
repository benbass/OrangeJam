import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/core/audiohandler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../../../application/my_listview/ui/is_scroll_reverse_cubit.dart';
import '../../../../application/my_listview/ui/is_scrolling_cubit.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../../../injection.dart';
import '../../../../core/format_duration.dart';
import '../../../../core/playlist_handler.dart';
import 'listitem_slidable.dart';

class MyListview extends StatelessWidget {
  final List<TrackEntity> tracks;
  final ScrollController sctr;
  final ListObserverController observController;
  final IsScrollingCubit isScrollingCubit;
  final IsScrollReverseCubit isScrollReverseCubit;
  final MyAudioHandler audioHandler;
  final Function gotoItem;
  final PlaylistHandler playlistHandler;

  const MyListview({
    super.key,
    required this.tracks,
    required this.sctr,
    required this.observController,
    required this.isScrollingCubit,
    required this.isScrollReverseCubit,
    required this.audioHandler,
    required this.gotoItem,
    required this.playlistHandler,
  });

  @override
  Widget build(BuildContext context) {
    final trackPositionCubit = BlocProvider.of<TrackPositionCubit>(context);
    final trackDurationCubit = BlocProvider.of<TrackDurationCubit>(context);
    final continuousPlaybackModeCubit =
        BlocProvider.of<ContinuousPlaybackModeCubit>(context);
    final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(context);

    final themeData = Theme.of(context);

    int selectedTrackId = -1;

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

    // This method handles behaviour of player at end of track
    startPositionMonitoring() {
      bool hasStoppedChanging = false;
      //trackPositionCubit.setPosition(const Duration(milliseconds: 1));

      Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        if (unformatedDuration(trackDurationCubit.state) - 1500 <
            unformatedDuration(trackPositionCubit.state!)) {
          hasStoppedChanging = true;
          timer.cancel();
          if (hasStoppedChanging == true) {
            if (continuousPlaybackModeCubit.state) {
              sl<PlayerControlsBloc>().add(NextButtonPressed());
              // Delay -> ensure timer starts when when new track duration is known
              Future.delayed(const Duration(milliseconds: 2000),
                  startPositionMonitoring());
            } else if (isLoopModeCubit.state) {
              // we need current index in case user sorted or filtered the list
              int index =
              tracks.indexWhere((element) => element.id == selectedTrackId);
              audioHandler.flutterSoundPlayer
                  .startPlayer(fromURI: tracks[index].filePath);
              startPositionMonitoring();
            } else {
              sl<PlayerControlsBloc>().add(InitialPlayerControls());
              audioHandler.cancelNotification();
            }
          }
        } else if (selectedTrackId == -1) {
          timer.cancel();
        }
      });
    }

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
                    return SizedBox(
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

              return ItemSlidable(
                key: Key(index.toString()),
                index: index,
                track: track,
                backgroundColor: backgroundColor,
                selectedTrackId: selectedTrackId,
                audioHandler: audioHandler,
                themeData: themeData,
                textColor: textColor,
                startPositionMonitoring: startPositionMonitoring,
                playlistHandler: playlistHandler,
              );
            }),
      );
    });
  }
}
