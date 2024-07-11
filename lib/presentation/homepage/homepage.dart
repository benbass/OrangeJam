import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/language/language_cubit.dart';
import 'package:orange_player/core/initialize_awesome_notifications.dart';
import 'package:orange_player/presentation/drawer/drawer.dart';
import 'package:orange_player/presentation/homepage/progress_indicator/progress_indicator.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orange_player/application/playlists/playlists_bloc.dart';
import 'package:orange_player/application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import 'package:orange_player/presentation/homepage/player_controls/player_controls.dart';
import 'package:orange_player/application/listview/ui/is_scrolling_cubit.dart';
import '../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../application/listview/tracklist/tracklist_bloc.dart';
import '../../core/create_notification.dart';
import '../../core/globals.dart';
import '../../core/set_app_language.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../core/audiohandler.dart';
import '../../core/playlist_handler.dart';
import 'appbar/appbar_content.dart';
import 'custom_widgets/custom_widgets.dart';
import 'extra_bar_under_appbar/extra_bar.dart';
import 'bottombar/widgets/goto_item_icon.dart';
import 'bottombar/widgets/playlists_icon_button.dart';
import 'bottombar/widgets/show_hide_playercontrols.dart';
import 'error/error_message.dart';
import 'listview/listview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    setAppLanguage(context);


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
        ? createNotification(audioHandler.selectedId, audioHandler.currentTrack, audioHandler.isPausingState, audioHandler.p)
        : {};
    void onInactive() => sl<PlayerControlsBloc>().state.track.id != -1
        ? createNotification(audioHandler.selectedId, audioHandler.currentTrack, audioHandler.isPausingState, audioHandler.p)
        : {};
    void onHidden() => sl<PlayerControlsBloc>().state.track.id != -1
        ? createNotification(audioHandler.selectedId, audioHandler.currentTrack, audioHandler.isPausingState, audioHandler.p)
        : {};
    void onPaused() => sl<PlayerControlsBloc>().state.track.id != -1
        ? createNotification(audioHandler.selectedId, audioHandler.currentTrack, audioHandler.isPausingState, audioHandler.p)
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

    return BlocConsumer<LanguageCubit, String>(
      listener: (context, state) {
        S.load(Locale(state));
      },
      builder: (context, state) => Scaffold(
        key: globalScaffoldKey.scaffoldKey,
        appBar: AppBar(
          title: AppBarContent(themeData: themeData),
        ),

        endDrawer: MyDrawer(
          supportedLang: S.delegate.supportedLocales,
        ),
        body: SizedBox(
          height: double.infinity,
          child: BlocBuilder<TracklistBloc, TracklistState>(
            builder: (context, tracklistState) {
              if (tracklistState is TracklistInitial) {
                tracklistBloc.add(TrackListLoadingEvent());
                return CustomProgressIndicator(
                    progressText: S.of(context).homePage_ScanningDevice,
                    themeData: themeData);
              } else if (tracklistState is TracklistStateLoading) {
                /// we send the data from source to the playlist bloc so playlist can be built
                playlistsBloc
                    .add(PlaylistsLoadingEvent(tracks: tracklistState.tracks));
                tracklistBloc.add(TrackListLoadedEvent());
                return CustomProgressIndicator(
                    progressText: S.of(context).homePage_LoadingTracks,
                    themeData: themeData);
              } else if (tracklistState is TracklistStateLoaded) {
                // Player is open so we can subscribe
                if (audioHandler.flutterSoundPlayer.isOpen()) {
                  // Position for Progressbar in Player controls and behaviour at track end
                  audioHandler.flutterSoundPlayer.setSubscriptionDuration(
                      const Duration(milliseconds: 100));
                  //init and check permission of awesomeNotifications
                  initAwesomeNotifications();
                }
                return BlocBuilder<PlaylistsBloc, PlaylistsState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        state.playlistId < 0

                            /// Extra bar for all files and queue
                            ? SortFilterSearchAndQueueMenu(
                                playlistsBloc: playlistsBloc,
                                searchController: searchController,
                                appbarFilterByCubit: appbarFilterByCubit,
                                playlistHandler: playlistHandler,
                              )
                            : const SizedBox.shrink(),

                        /// listview shows the list of tracks: no extra bar will be shown on top if this is a playlist (id < 0)
                        Expanded(
                          child: RawScrollbar(
                            trackVisibility: true,
                            thickness: 8.0,
                            thumbColor:
                                const Color(0xFFFF8100).withOpacity(0.7),
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
                                          color:
                                              themeData.colorScheme.secondary,
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
            /// Go to item
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
                buildPlaylistStringsForDropDownMenu(playlistHandler);
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
      ),
    );
  }
}
