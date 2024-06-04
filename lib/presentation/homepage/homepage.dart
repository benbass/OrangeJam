import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../application/bottombar/playlists/is_comm_with_google_cubit.dart';
import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/application/my_listview/ui/appbar_filterby_cubit.dart';
import 'package:orange_player/presentation/homepage/intrinsic_height/widgets/filterby_dynamic_menu.dart';
import 'package:orange_player/presentation/homepage/intrinsic_height/widgets/sortby_dropdown.dart';
import 'package:orange_player/presentation/homepage/player_controls/widgets/player_controls.dart';
import 'package:orange_player/application/my_listview/ui/is_scrolling_cubit.dart';
import '../../application/my_listview/ui/is_scroll_reverse_cubit.dart';
import '../../application/my_listview/tracklist/tracklist_bloc.dart';
import '../../domain/entities/track_entity.dart';
import '../../injection.dart';
import '../../services/notification_controller.dart';
import '../../core/audiohandler.dart';
import 'dialogs/widgets/custom_widgets.dart';
import '../../core/playlist_handler.dart';
import 'intrinsic_height/widgets/search.dart';
import 'bottombar/widgets/goto_item_icon.dart';
import 'bottombar/widgets/playlists_menu.dart';
import 'bottombar/widgets/show_hide_playercontrols.dart';
import 'error/widgets/error_message.dart';
import 'my_listview/widgets/my_listview.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  late GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyAudioHandler audioHandler = sl<MyAudioHandler>();
    final tracklistBloc = BlocProvider.of<TracklistBloc>(context);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final isScrollingCubit = BlocProvider.of<IsScrollingCubit>(context);
    final isScrollReverseCubit = BlocProvider.of<IsScrollReverseCubit>(context);
    final appbarFilterByCubit = BlocProvider.of<AppbarFilterByCubit>(context);
    final themeData = Theme.of(context);
    PlaylistHandler playlistHandler = PlaylistHandler(playlists: []);

    // Suchfeld
    final TextEditingController searchController = TextEditingController();

    ScrollController sctr = ScrollController();
    // This ListObserverController works much better than ScrollController for animateTo since it uses index instead of pixel
    ListObserverController observerController =
        ListObserverController(controller: sctr);

    void gotoItem(double offset) {
      // we need current index in case user sorted or filtered the list
      // 1. so first we get current track id
      int selectedTrackId = audioHandler
          .selectedId; //BlocProvider.of<PlayerControlsBloc>(context).state.track.id;

      // 2. and we need index of this current track in current list state
      int index = playlistsBloc.state.tracks
          .indexWhere((element) => element.id == selectedTrackId);

      observerController.animateTo(
        alignment: 0,
        index: index,
        offset: (_) => offset,
        isFixedHeight: true,
        padding: const EdgeInsets.only(bottom: 200),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    }

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
      key: myGlobals.scaffoldKey,
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
                AwesomeNotifications().initialize(
                    // set the icon to null if you want to use the default app icon
                    null, //'resource://drawable/res_app_icon',
                    [
                      NotificationChannel(
                        channelGroupKey: 'basic_channel_group',
                        channelKey: 'basic_channel',
                        channelName: 'Orange Player Track Playing',
                        channelDescription:
                            'Notification channel for the Orange Player',
                        //defaultColor: const Color(0xFFFF8100),
                        //ledColor: Colors.white,
                        playSound: false,
                        enableVibration: false,
                        importance: NotificationImportance.High,
                        channelShowBadge: false,
                        locked: true,
                        defaultPrivacy: NotificationPrivacy.Public,
                        icon: "resource://drawable/launcher_icon",
                      )
                    ],
                    debug: true);
                // Only after at least the action method is set, the notification events are delivered
                AwesomeNotifications().setListeners(
                  onActionReceivedMethod:
                      NotificationController.onActionReceivedMethod,
                );
                /*
                onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
                onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
                onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
                */
              }
              AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
                if (!isAllowed) {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      content: const Text(
                          'Our app would like to send you notifications'),
                      actions: [
                        SimpleButton(
                          themeData: themeData,
                          btnText: 'Don\'t Allow',
                        ),
                        ElevatedButton(
                          onPressed: () => AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((_) => Navigator.pop(context)),
                          style: themeData.elevatedButtonTheme.style,
                          child: const Text('Allow'),
                        ),
                      ],
                      showDropdown: false,
                      titleWidget: DescriptionText(
                        themeData: themeData,
                        description: 'Allow Notifications',
                      ),
                      themeData: themeData,
                    ),
                  );
                }
              });
              return BlocBuilder<PlaylistsBloc, PlaylistsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      state.playlistId < 0
                          ? IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: playlistsBloc.state.playlistId != -1
                                    ? [
                                        const Expanded(
                                          flex: 10,
                                          child: SortBy(),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: SizedBox.expand(),
                                        ),
                                        const Expanded(
                                          flex: 7,
                                          child: FilterByDynamicMenu(),
                                        ),
                                        Expanded(
                                          flex: 9,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0, top: 0),
                                            child: SearchWidget(
                                              searchController:
                                                  searchController,
                                              appbarFilterByCubit:
                                                  appbarFilterByCubit,
                                            ),
                                          ),
                                        ),
                                      ]
                                    : [
                                        const Expanded(
                                          child: SizedBox(
                                            height: 50,
                                          ),
                                        ),
                                        InkWell(
                                          child: const Text("Clear"),
                                          onTap: () {
                                            playlistsBloc.add(ClearQueue());
                                          },
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                        InkWell(
                                          child: const Text("Save"),
                                          onTap: () {
                                            if (playlistsBloc
                                                .state.tracks.isNotEmpty) {
                                              List<String> filePaths = [];
                                              for (TrackEntity track
                                                  in playlistsBloc
                                                      .state.tracks) {
                                                filePaths.add(track.file.path);
                                              }
                                              playlistHandler.createPlaylist(
                                                "Save the queue as a playlist:",
                                                filePaths,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      "The queue is empty!"),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const Expanded(
                                          child: SizedBox(),
                                        ),
                                      ],
                              ),
                            )
                          : const SizedBox.shrink(),
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
                                gotoItem: gotoItem,
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
                // Sort
                //const SortBy(),
                BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
                  builder: (context, state) {
                    if (state.track.id != -1) {
                      return GotoItemIcon(
                        isScrollReverseCubit: isScrollReverseCubit,
                        isScrollingCubit: isScrollingCubit,
                        gotoItem: gotoItem,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          // Playlists
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
          // Show/Hide player controls
          const Expanded(
            flex: 2,
            child: ShowHidePlayerControls(),
          ),
        ],
      ),
      bottomSheet: BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
        builder: (context, state) {
          return PlayerControls(
            track: state.track,
            gotoItem: gotoItem,
          );
        },
      ),
    );
  }
}
