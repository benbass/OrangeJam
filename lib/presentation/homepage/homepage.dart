import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/core/storage_permission/storage_permission_handler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/presentation/homepage/player_controls/player_controls.dart';
import 'package:orangejam/application/listview/ui/is_scrolling_cubit.dart';
import '../../application/listview/ui/is_scroll_reverse_cubit.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';
import 'package:orangejam/presentation/drawer/drawer.dart';
import '../../application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import '../../core/notifications/create_notification.dart';
import '../../core/helpers/app_language.dart';
import '../../core/notifications/initialize_awesome_notifications.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../core/player/audiohandler.dart';
import 'appbar/appbar_content.dart';
import 'custom_widgets/error/error_message.dart';
import 'custom_widgets/progress_indicator/progress_indicator.dart';
import 'bottombar/widgets/goto_item_icon.dart';
import 'bottombar/widgets/playlists_menu_button.dart';
import 'bottombar/widgets/show_hide_playercontrols.dart';
import 'extra_top_bar/extra_top_bar.dart';
import 'listview/listview.dart';

/// TODO: permission handler for iOS

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  void openPlayer() async{
    await sl<MyAudioHandler>().flutterSoundPlayer.openPlayer();
    // Player is open so we can subscribe
    if (sl<MyAudioHandler>().flutterSoundPlayer.isOpen()) {
      // Position for Progressbar in Player controls and behaviour at playback end
      sl<MyAudioHandler>().flutterSoundPlayer.setSubscriptionDuration(
          const Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Now we have the context so we can initialize and register audioHandler with it
    late MyAudioHandler audioHandler;
    // For development purpose we need to check if dependency is already registered
    // in order to avoid error at hot reload!
    if(!sl.isRegistered<MyAudioHandler>()) {
      audioHandler = MyAudioHandler(context);
      sl.registerLazySingleton<MyAudioHandler>(() => audioHandler);
      openPlayer();
    }

    // app language will be set based on shared drawer_prefs if set. Default lang is en.
    setAppLanguage(context);

    //init and check permission for awesomeNotifications
    initAwesomeNotifications(context);

    final StoragePermissionHandler storagePermissionHandler =
        StoragePermissionHandler(context: context);
    final isScrollingCubit = BlocProvider.of<IsScrollingCubit>(context);
    final isScrollReverseCubit = BlocProvider.of<IsScrollReverseCubit>(context);
    final automaticPlaybackCubit =
        BlocProvider.of<AutomaticPlaybackCubit>(context);

    final SearchController searchController = SearchController();

    final ScrollController sctr = ScrollController();
    // This ListObserverController works much better than ScrollController for animateTo since it uses index instead of pixel
    final ListObserverController observerController =
        ListObserverController(controller: sctr);

    void updateNotificationIfNeeded() {
      if (sl<MyAudioHandler>().id != 0) {
        createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.currentPosition);
      }
    }

    // Trying to "dispose" the player when closing the app.
    void onDetached() => audioHandler.flutterSoundPlayer.closePlayer();

    // We update notification (Play/Pause button, position)
    // track id 0 is empty track: occurs at app start or when player is stopped
    // notification should live only when track is not empty
    void onResumed() {
      updateNotificationIfNeeded();
      if(Platform.isAndroid) {
        storagePermissionHandler.checkStoragePermissionOnResumed();
      }
    }

    // Listen to the app lifecycle state changes
    void onStateChanged(AppLifecycleState state) {
      switch (state) {
        case AppLifecycleState.detached:
          onDetached();
          break;
        case AppLifecycleState.resumed:
          onResumed();
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.hidden:
        case AppLifecycleState.paused:
          updateNotificationIfNeeded();
          break;
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
      builder: (context, state) {
        // The dialog is called only if permission is permanently denied
        storagePermissionHandler.callDialogForStoragePermission();
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Scaffold(
            //key: globalScaffoldKey.scaffoldKey,
            appBar: AppBar(
              title: const AppBarContent(),
            ),
            endDrawer: MyDrawer(
              supportedLang: S.delegate.supportedLocales,
            ),
            body: SizedBox(
              height: double.infinity,
              child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
                //bloc: BlocProvider.of<PlaylistsBloc>(context),
                builder: (context, playlistsState) {
                  if (playlistsState.loading) {
                    // Check sharedPrefs for automatic playback and emit state according to result
                    automaticPlaybackCubit.getAutomaticPlaybackFromPrefs();
                    //
                    return CustomProgressIndicator(
                      progressText: S.of(context).homePage_LoadingTracks,
                    );
                  } else if (!playlistsState.loading) {
                    //init and check permission for awesomeNotifications
                    //initAwesomeNotifications(context);

                    /// List of tracks, extra top bar (if any, depending on kind of list)
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// No extra bar will be shown on top if current list is a user playlist (id >= 0)
                        playlistsState.playlistId < 0

                            /// Extra bar only for views: all files, queue
                            ? ExtraTopBar(
                                searchController: searchController,
                              )
                            : const SizedBox.shrink(),

                        /// The list of tracks
                        MyListview(
                          sctr: sctr,
                          observController: observerController,
                          isScrollingCubit: isScrollingCubit,
                          isScrollReverseCubit: isScrollReverseCubit,
                        ),
                      ],
                    );
                  } else if (playlistsState.message != null) {
                    return ErrorMessage(
                      message: playlistsState.message!,
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
                  child: GotoItemIcon(
                    isScrollReverseCubit: isScrollReverseCubit,
                    isScrollingCubit: isScrollingCubit,
                    observerController: observerController,
                  ),
                ),

                /// Playlists menu
                Expanded(
                  child: PlaylistsMenuButton(
                    scrollController: sctr,
                  ),
                ),

                /// Show/Hide player controls
                const Expanded(
                  flex: 2,
                  child: ShowHidePlayerControls(),
                ),
              ],
            ),

            /// Player controls
            bottomSheet: PlayerControls(
              observerController: observerController,
            ),
          ),
        );
      },
    );
  }
}
