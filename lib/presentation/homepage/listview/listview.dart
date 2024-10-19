import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../../application/listview/ui/is_scrolling_cubit.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../core/playlists/playlist_handler.dart';
import '../extra_top_bar/extra_top_bar.dart';
import 'widgets/list_item_slidable.dart';

class MyListview extends StatelessWidget {
  final ScrollController sctr;
  final ListObserverController observController;
  final IsScrollingCubit isScrollingCubit;
  final IsScrollReverseCubit isScrollReverseCubit;

  const MyListview({
    super.key,
    required this.sctr,
    required this.observController,
    required this.isScrollingCubit,
    required this.isScrollReverseCubit,
  });

  @override
  Widget build(BuildContext context) {

    final themeData = Theme.of(context);

    // Search field
    final TextEditingController searchController = TextEditingController();

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

    void reorderItem(int oldIndex, int newIndex, PlaylistsState state){
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      TrackEntity track = state.tracks[oldIndex];
      state.tracks.removeAt(oldIndex); // Update UI
      state.tracks.insert(newIndex, track);
      // If this is a playlist, we save new order
      if (state.playlistId > -1) {
        state.playlists[state.playlistId][1]
            .remove(track.filePath);
        state.playlists[state.playlistId][1]
            .insert(newIndex, track.filePath);

        PlaylistHandler().reorderLinesInFile(
            state.playlists[state.playlistId][0],
            oldIndex,
            newIndex);
      }
    }

    final playerControlsState = context.watch<PlayerControlsBloc>().state;

    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        return Column(
          children: [
            /// listview shows the list of tracks: no extra bar will be shown on top if this is a playlist (id >= 0)
            state.playlistId < 0

                /// Extra bar for views all files and queue
                ? ExtraTopBar(
                    searchController: searchController,
                  )
                : const SizedBox.shrink(),

            /// The list
            Expanded(
              child: RawScrollbar(
                thumbVisibility: false,
                fadeDuration: const Duration(milliseconds: 0),
                timeToFade: const Duration(milliseconds: 0),
                thickness: 4.5,
                thumbColor: const Color(0xFFFF8100).withOpacity(0.7),
                controller: sctr,
                child: Stack(
                  children: [
                    ListViewObserver(
                      controller: observController,
                      child: ReorderableListView.builder(
                          shrinkWrap: true,
                          itemExtent: 73,
                          scrollController: sctr,
                          physics: const BouncingScrollPhysics(),
                          onReorder: (int oldIndex, int newIndex) {
                            reorderItem(oldIndex, newIndex, state);
                          },
                          footer: OrientationBuilder(
                            builder: (context, orientation) {
                              if (orientation == Orientation.portrait) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 600),
                                  height: playerControlsState.height == 200
                                      ? 200
                                      : 0,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          itemCount: state.tracks.length,
                          itemBuilder: (BuildContext context, int index) {
                            final TrackEntity track = state.tracks[index];
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
                              themeData: themeData,
                              textColor: textColor,
                            );
                          }),
                    ),
                    BlocBuilder<IsCommWithGoogleCubit, bool>(
                      builder: (context, state) {
                        // progress indicator in case of backup/restore
                        return Visibility(
                          visible: state,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: themeData.colorScheme.secondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
