import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/language/language_cubit.dart';
import 'package:orangejam/core/notifications/initialize_awesome_notifications.dart';
import 'package:orangejam/presentation/drawer/drawer.dart';
import 'package:orangejam/presentation/homepage/progress_indicator/progress_indicator.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import 'package:orangejam/presentation/homepage/player_controls/player_controls.dart';
import 'package:orangejam/application/listview/ui/is_scrolling_cubit.dart';
import '../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../application/listview/tracklist/tracklist_bloc.dart';
import '../../core/notifications/create_notification.dart';
import '../../core/globals.dart';
import '../../core/helpers/app_language.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../core/player/audiohandler.dart';
import '../../core/playlists/playlist_handler.dart';
import 'appbar/appbar_content.dart';
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
    // app language will be set based on shared prefs if set. Default lang. is en.
    setAppLanguage(context);

    final MyAudioHandler audioHandler = sl<MyAudioHandler>();
    final tracklistBloc = BlocProvider.of<TracklistBloc>(context);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final isScrollingCubit = BlocProvider.of<IsScrollingCubit>(context);
    final isScrollReverseCubit = BlocProvider.of<IsScrollReverseCubit>(context);
    final appbarFilterByCubit = BlocProvider.of<AppbarFilterByCubit>(context);
    final themeData = Theme.of(context);
    PlaylistHandler playlistHandler = PlaylistHandler(playlists: []);

    // Search field
    final TextEditingController searchController = TextEditingController();

    final ScrollController sctr = ScrollController();
    // This ListObserverController works much better than ScrollController for animateTo since it uses index instead of pixel
    final ListObserverController observerController =
        ListObserverController(controller: sctr);

    // Trying to "dispose" the player when closing the app.
    void onDetached() => audioHandler.flutterSoundPlayer.closePlayer();

    // We update notification (Play/Pause)
    // track id 0 is empty track: occurs at app start or when player is stopped
    // notification should live only when track is not empty
    void onResumed() => sl<PlayerControlsBloc>().state.track.id != 0
        ? createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.p)
        : {};
    void onInactive() => sl<PlayerControlsBloc>().state.track.id != 0
        ? createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.p)
        : {};
    void onHidden() => sl<PlayerControlsBloc>().state.track.id != 0
        ? createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.p)
        : {};
    void onPaused() => sl<PlayerControlsBloc>().state.track.id != 0
        ? createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.p)
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
                // we get the tracks from the objectBox db. If db is empty, device will be scanned,
                // files will be converted to entities with metadata and put into db (slow!).
                // See tracklist_datasources.dart in infrastructure layer!
                tracklistBloc.add(TrackListLoadingEvent());
                return CustomProgressIndicator(
                    progressText: S.of(context).homePage_ScanningDevice,
                    themeData: themeData);
              } else if (tracklistState is TracklistStateLoading) {
                /// we send the data from source (the tracks) to the playlist bloc so playlists can be built
                playlistsBloc
                    .add(PlaylistsLoadingEvent(tracks: tracklistState.tracks));
                tracklistBloc.add(TrackListLoadedEvent());
                return CustomProgressIndicator(
                    progressText: S.of(context).homePage_LoadingTracks,
                    themeData: themeData);
              } else if (tracklistState is TracklistStateLoaded) {
                // Player is open so we can subscribe
                if (audioHandler.flutterSoundPlayer.isOpen()) {
                  // Position for Progressbar in Player controls and behaviour at playback end
                  audioHandler.flutterSoundPlayer.setSubscriptionDuration(
                      const Duration(milliseconds: 100));
                  //init and check permission for awesomeNotifications
                  initAwesomeNotifications();
                }
                return BlocBuilder<PlaylistsBloc, PlaylistsState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        state.playlistId < 0

                            /// Extra bar for views all files and queue
                            ? SortFilterSearchAndQueueMenu(
                                playlistsBloc: playlistsBloc,
                                searchController: searchController,
                                appbarFilterByCubit: appbarFilterByCubit,
                                playlistHandler: playlistHandler,
                              )
                            : const SizedBox.shrink(),

                        /// listview shows the list of tracks: no extra bar will be shown on top if this is a playlist (id >= 0)
                        Expanded(
                          child: RawScrollbar(
                            //trackVisibility: true,
                            thumbVisibility: false,
                            fadeDuration: const Duration(milliseconds: 0),
                            timeToFade: const Duration(milliseconds: 0),
                            thickness: 4.5,
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
                                    // progress indicator in case of backup/restore
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
            /// jump to item button
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
                    builder: (context, state) {
                      if (state.track.id != 0) {
                        // button is shown only if a track is playing && list is scrolled
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
                // we need the names of the playlists as strings
                playlistHandler.buildPlaylistStrings();
                return Expanded(
                  child: MenuPlaylistsWidget(
                    scrollController: sctr,
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
