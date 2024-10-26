import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/presentation/homepage/player_controls/player_controls.dart';
import 'package:orangejam/application/listview/ui/is_scrolling_cubit.dart';
import '../../application/listview/ui/is_scroll_reverse_cubit.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';
import 'package:orangejam/presentation/drawer/drawer.dart';
import '../../application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import '../../core/notifications/create_notification.dart';
import '../../core/globals.dart';
import '../../core/helpers/app_language.dart';
import '../../core/notifications/initialize_awesome_notifications.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../core/player/audiohandler.dart';
import 'appbar/appbar_content.dart';
import 'custom_widgets/custom_widgets.dart';
import 'custom_widgets/error/error_message.dart';
import 'custom_widgets/progress_indicator/progress_indicator.dart';
import 'bottombar/widgets/goto_item_icon.dart';
import 'bottombar/widgets/playlists_menu_button.dart';
import 'bottombar/widgets/show_hide_playercontrols.dart';
import 'extra_top_bar/extra_top_bar.dart';
import 'listview/listview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // app language will be set based on shared drawer_prefs if set. Default lang is en.
    setAppLanguage(context);

    final MyAudioHandler audioHandler = sl<MyAudioHandler>();
    final isScrollingCubit = BlocProvider.of<IsScrollingCubit>(context);
    final isScrollReverseCubit = BlocProvider.of<IsScrollReverseCubit>(context);
    final automaticPlaybackCubit =
        BlocProvider.of<AutomaticPlaybackCubit>(context);

    final SearchController searchController = SearchController();

    final ScrollController sctr = ScrollController();
    // This ListObserverController works much better than ScrollController for animateTo since it uses index instead of pixel
    final ListObserverController observerController =
        ListObserverController(controller: sctr);

    void refreshUi() {
      BlocProvider.of<PlaylistsBloc>(context)
          .add(PlaylistsTracksLoadingEvent());
    }

    void checkStoragePermissionOnResumed() async {
      // Storage permission may be permanently denied but
      // user may grant permission later in app settings: if so, we can now scan device and refresh UI.
      late bool granted;
      if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
        granted = await Permission.storage.isGranted;
      } else {
        granted = await Permission.audio.isGranted;
      }
      // We scan device only if track list is empty. Doing so, we prevent a scan at each resume
      // An empty list can indicate that permission was never granted
      if (granted && sl<GlobalLists>().initialTracks.isEmpty) {
        refreshUi();
      }
    }

    void permissionDialog() async {
      bool sdkAtLeast33 = await mediaStorePlugin.getPlatformSDKInt() < 33;
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            content: Text(!sdkAtLeast33
                ? S.of(context).storage_permissions_dialog_content_33
                : S.of(context).storage_permissions_dialog_content),
            actions: [
              SimpleButton(
                btnText: S.of(context).buttonCancel,
                function: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              SimpleButton(
                btnText: S.of(context).buttonOk,
                function: () {
                  openAppSettings().then((value) {
                    if (value == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ],
            showDropdown: false,
            titleWidget: DescriptionText(
              description: S.of(context).storage_permissions_dialog_description,
            ),
          ),
        );
      }
    }

    void callDialogForStoragePermission() async {
      late bool permanentlyDenied;
      if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
        permanentlyDenied = await Permission.storage.isPermanentlyDenied;
      } else {
        permanentlyDenied = await Permission.audio.isPermanentlyDenied;
      }
      if (permanentlyDenied) {
        permissionDialog();
      }
    }

    void updateNotificationIfNeeded() {
      if (sl<PlayerControlsBloc>().state.track.id != 0) {
        createNotification(audioHandler.currentTrack,
            audioHandler.isPausingState, audioHandler.p);
      }
    }

    // Trying to "dispose" the player when closing the app.
    void onDetached() => audioHandler.flutterSoundPlayer.closePlayer();

    // We update notification (Play/Pause)
    // track id 0 is empty track: occurs at app start or when player is stopped
    // notification should live only when track is not empty
    void onResumed() {
      updateNotificationIfNeeded();
      checkStoragePermissionOnResumed();
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
      builder: (context, state) => SafeArea(
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
                callDialogForStoragePermission(); // Dialog will be shown only if permission is permanently denied

                if (playlistsState.loading) {
                  // Player is open so we can subscribe
                  if (audioHandler.flutterSoundPlayer.isOpen()) {
                    // Position for Progressbar in Player controls and behaviour at playback end
                    audioHandler.flutterSoundPlayer.setSubscriptionDuration(
                        const Duration(milliseconds: 100));
                  }

                  // Check sharedPrefs for automatic playback and emit state according to result
                  automaticPlaybackCubit.getAutomaticPlaybackFromPrefs();
                  //
                  return CustomProgressIndicator(
                    progressText: S.of(context).homePage_LoadingTracks,
                  );
                } else if (!playlistsState.loading) {
                  //init and check permission for awesomeNotifications
                  initAwesomeNotifications(context);

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
      ),
    );
  }
}
