import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/core/initialize_awesome_notifications.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../application/bottombar/playlists/is_comm_with_google_cubit.dart';
import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/application/my_listview/ui/appbar_filterby_cubit.dart';
import 'package:orange_player/presentation/homepage/player_controls/widgets/player_controls.dart';
import 'package:orange_player/application/my_listview/ui/is_scrolling_cubit.dart';
import '../../application/my_listview/ui/is_scroll_reverse_cubit.dart';
import '../../application/my_listview/tracklist/tracklist_bloc.dart';
import '../../core/animate_to_index.dart';
import '../../core/globals.dart';
import '../../injection.dart';
import '../../core/audiohandler.dart';
import '../../core/playlist_handler.dart';
import 'intrinsic_height/sort_filter_search_menu.dart';
import 'bottombar/widgets/goto_item_icon.dart';
import 'bottombar/widgets/playlists_menu.dart';
import 'bottombar/widgets/show_hide_playercontrols.dart';
import 'error/widgets/error_message.dart';
import 'my_listview/widgets/my_listview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MyAudioHandler audioHandler = sl<MyAudioHandler>();
    final tracklistBloc = BlocProvider.of<TracklistBloc>(context);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final isScrollingCubit = BlocProvider.of<IsScrollingCubit>(context);
    final isScrollReverseCubit = BlocProvider.of<IsScrollReverseCubit>(context);
    final appbarFilterByCubit = BlocProvider.of<AppbarFilterByCubit>(context);
    final themeData = Theme.of(context);
    PlaylistHandler playlistHandler = PlaylistHandler(playlists: []);

    // Suchfeld
    final TextEditingController searchController = TextEditingController();

    final ScrollController sctr = ScrollController();
    // This ListObserverController works much better than ScrollController for animateTo since it uses index instead of pixel
    final ListObserverController observerController =
        ListObserverController(controller: sctr);

    // Trying to "dispose" the player when closing the app.
    void onDetached() => audioHandler.flutterSoundPlayer.closePlayer();

    // We update notification (Play/Pause)
    void onResumed() => sl<PlayerControlsBloc>().state.track.id != -1
        ? audioHandler.createNotification()
        : {};
    void onInactive() => sl<PlayerControlsBloc>().state.track.id != -1
        ? audioHandler.createNotification()
        : {};
    void onHidden() => sl<PlayerControlsBloc>().state.track.id != -1
        ? audioHandler.createNotification()
        : {};
    void onPaused() => sl<PlayerControlsBloc>().state.track.id != -1
        ? audioHandler.createNotification()
        : {};

    // Listen to the app lifecycle state changes
    void onStateChanged(AppLifecycleState state) {
      switch (state) {
        case AppLifecycleState.detached:
          onDetached();
        case AppLifecycleState.resumed:
          onResumed();
        case AppLifecycleState.inactive:
          onInactive();
        case AppLifecycleState.hidden:
          onHidden();
        case AppLifecycleState.paused:
          onPaused();
      }
    }

    // Initialize the AppLifecycleListener class and pass callbacks
    AppLifecycleListener(
      onStateChange: onStateChanged,
    );

    return Scaffold(
      key: globalScaffoldKey.scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
                  builder: (context, state) {
                    if (state.playlistId == -2) {
                      return Text(
                        "Files (${state.tracks.length})",
                      );
                    } else if (state.playlistId == -1) {
                      return Text(
                        "Queue (${state.tracks.length})",
                      );
                    } else if (state.playlistId > -1) {
                      return Text(
                        "${state.playlists[state.playlistId][0]} (${state.tracks.length})",
                        overflow: TextOverflow.ellipsis,
                        //"Playlist",
                      );
                    } else {
                      return Text(
                        "Files (${state.tracks.length})",
                      );
                    }
                  },
                )),
            const SizedBox(
              width: 20,
            ),

            /// This builder shows a sort of filtering navigation: filtertext1 > filtertext2 > filtertext3...
            BlocBuilder<AppbarFilterByCubit, String?>(
              builder: (context, appbarFilterByState) {
                return Expanded(
                  flex: 2,
                  child: appbarFilterByState != null
                      ? Text(
                          appbarFilterByState,
                          style: themeData.appBarTheme.titleTextStyle?.copyWith(
                            color: const Color(0xFFFF8100),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.end,
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: BlocBuilder<TracklistBloc, TracklistState>(
          builder: (context, tracklistState) {
            if (tracklistState is TracklistInitial) {
              tracklistBloc.add(TrackListLoadingEvent());
              return Center(
                child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary,
                ),
              );
            } else if (tracklistState is TracklistStateLoading) {
              playlistsBloc
                  .add(PlaylistsLoadingEvent(tracks: tracklistState.tracks));
              tracklistBloc.add(TrackListLoadedEvent());
              return Center(
                child: CircularProgressIndicator(
                  color: themeData.colorScheme.secondary,
                ),
              );
            } else if (tracklistState is TracklistStateLoaded) {
              // Player is open so we can subscribe
              if (audioHandler.flutterSoundPlayer.isOpen()) {
                // Position for Progressbar in Player controls and behaviour at track end
                audioHandler.flutterSoundPlayer
                    .setSubscriptionDuration(const Duration(milliseconds: 100));
                //init and check permission of awesomeNotifications
                initAwesomeNotifications();
              }
              return BlocBuilder<PlaylistsBloc, PlaylistsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      state.playlistId < 0

                          /// all files or queue
                          ? SortFilterSearchMenu(
                              playlistsBloc: playlistsBloc,
                              searchController: searchController,
                              appbarFilterByCubit: appbarFilterByCubit,
                              playlistHandler: playlistHandler,
                            )
                          : const SizedBox.shrink(),

                      /// listview shows a playlist: no extra will be shown on top
                      Expanded(
                        child: RawScrollbar(
                          trackVisibility: true,
                          thickness: 8.0,
                          thumbColor: const Color(0xFFFF8100).withOpacity(0.7),
                          controller: sctr,
                          //shape: const OvalBorder(),
                          child: Stack(
                            children: [
                              MyListview(
                                sctr: sctr,
                                observController: observerController,
                                tracks: state.tracks,
                                audioHandler: audioHandler,
                                isScrollingCubit: isScrollingCubit,
                                isScrollReverseCubit: isScrollReverseCubit,
                                playlistHandler: playlistHandler,
                              ),
                              BlocBuilder<IsCommWithGoogleCubit, bool>(
                                builder: (context, state) {
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
            } else if (tracklistState is TracklistStateError) {
              return ErrorMessage(
                message: tracklistState.message,
              );
            }
            return Container();
          },
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort list + go to item in list
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Animate to item
                BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
                  builder: (context, state) {
                    if (state.track.id != -1) {
                      return GotoItemIcon(
                        isScrollReverseCubit: isScrollReverseCubit,
                        isScrollingCubit: isScrollingCubit,
                        observerController: observerController,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),

          /// Playlists menu
          BlocBuilder<PlaylistsBloc, PlaylistsState>(
            builder: (context, state) {
              playlistHandler = PlaylistHandler(playlists: state.playlists);
              playlistHandler.buildDropDownStrings();
              return Expanded(
                child: MenuPlaylistsWidget(
                  playlistHandler: playlistHandler,
                  appbarFilterByCubit: appbarFilterByCubit,
                  themeData: themeData,
                ),
              );
            },
          ),

          /// Show/Hide player controls
          const Expanded(
            flex: 2,
            child: ShowHidePlayerControls(),
          ),
        ],
      ),

      /// Player controls
      bottomSheet: BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
        builder: (context, state) {
          return PlayerControls(
            track: state.track,
            observerController: observerController,
          );
        },
      ),
    );
  }
}
