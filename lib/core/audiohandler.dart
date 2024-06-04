import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/application/playercontrols/cubits/track_duration_cubit.dart';
import 'package:orange_player/application/playercontrols/cubits/track_position_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;

import 'package:orange_player/application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orange_player/services/audio_session.dart';
import 'package:orange_player/injection.dart' as di;

/*
import '../application/bottomsheet/playercontrols/continuousplayback_mode_cubit.dart';
import '../application/bottomsheet/playercontrols/loop_mode_cubit.dart';
import '../application/bottomsheet/playercontrols/track_duration_cubit.dart';
*/

import '../domain/entities/track_entity.dart';
import '../presentation/homepage/homepage.dart';
import 'format_duration.dart';

class MyAudioHandler {
  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
  TrackDurationCubit trackDurationCubit = TrackDurationCubit();
  TrackPositionCubit trackPositionCubit = TrackPositionCubit();

  // we need the following vars for the notification
  late TrackEntity currentTrack;
  bool isPausingState = false;
  int selectedId = -1;
  //

  void openAudioSession() {
    di.sl<MyAudioSession>().audioSession();
  }

  /// NOTIFICATION ///
  void cancelNotification() {
    AwesomeNotifications().cancel(10);
  }

  Duration p = Duration.zero;

  void createNotification() async {
    // We create notification only if user tapped on a track.
    // This check is necessary in order to prevent errors when app is resumed or inactive and player is stopped,
    // in which case id == -1, which can causes issues...
    if (selectedId != -1) {
      Duration d = Duration(milliseconds: currentTrack.trackDuration!.toInt());

      final tempDir = await getTemporaryDirectory();
      String filePath = "";

      Uint8List? imageUint8List = currentTrack.albumArt;

      if (imageUint8List != null) {
        // Resize, crop, blur and compress album cover
        int w = 320;
        //final i.Image resizedImage = i.copyResize(i.decodeImage(imageUint8List)!, width: w);
        //final i.Image croppedImage = i.copyCrop(resizedImage, x: 0, y: w~/4, width: w, height: w~/2.25);
        //final i.Image blurredImage = i.gaussianBlur(resizedImage, radius: 0);
        final List<int> compressedBytes = i.encodePng(i.gaussianBlur(i.copyResize(i.decodeImage(imageUint8List)!, width: w), radius: 3));
        final File compressedFile = File('${tempDir.path}/image_compressed.png');
        compressedFile.writeAsBytesSync(compressedBytes);

        filePath = "file://${compressedFile.path}";
      } else {
        filePath = "asset://assets/album-placeholder.png";
      }

      String iconKey = !isPausingState ? 'pause' : 'play';
      NotificationPlayState notificationPlayState = isPausingState
          ? NotificationPlayState.paused
          : NotificationPlayState.playing;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          category: NotificationCategory.Transport,
          title: currentTrack.trackName,
          body: currentTrack.trackArtistNames,
          duration: d,
          progress: unformatedDuration(p).toInt() /
              unformatedDuration(d).toInt() *
              100,
          playbackSpeed: 1,
          largeIcon: filePath,
          bigPicture: filePath,
          icon: "resource://drawable/launcher_icon", // App icon
          backgroundColor: const Color(0x00FFFFFF),//Color(0xFFFF8100),
          autoDismissible: false,
          showWhen: false,
          notificationLayout: NotificationLayout.MediaPlayer,
          locked: true,
          playState: notificationPlayState,
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'STOP',
              icon: 'resource://drawable/res_ic_stop',
              label: 'Idle',
              autoDismissible: false,
              showInCompactView: true,
              enabled: true,
              actionType: ActionType.KeepOnTop),
          NotificationActionButton(
              key: 'SKIPPREV',
              icon: 'resource://drawable/res_ic_prev',
              label: 'Previous',
              autoDismissible: false,
              showInCompactView: true,
              enabled: true,
              actionType: ActionType.KeepOnTop),
          NotificationActionButton(
              key: 'SKIPNEXT',
              icon: 'resource://drawable/res_ic_next',
              label: 'Next',
              autoDismissible: false,
              showInCompactView: true,
              enabled: true,
              actionType: ActionType.KeepOnTop),
          NotificationActionButton(
              key: 'RESUMEPAUSE',
              icon: 'resource://drawable/res_ic_$iconKey',
              label: !di.sl<PlayerControlsBloc>().state.isPausing ? 'Pause' : 'Play',
              autoDismissible: false,
              showInCompactView: true,
              enabled: true,
              actionType: ActionType.KeepOnTop),
        ],
      );
    }
  }

  /// PLAYER CONTROLS ///
  void playTrack(TrackEntity track) {
    p = Duration.zero;
    isPausingState = false;
    currentTrack = track;
    selectedId = track.id;
    flutterSoundPlayer.startPlayer(fromURI: track.file.path);
    openAudioSession();
    createNotification();
    // Update progressbar in notification
    flutterSoundPlayer.onProgress?.listen((event) {
      p = event.position;
    });
  }

  void stopTrack() {
    flutterSoundPlayer.stopPlayer();
    AwesomeNotifications().cancel(10);
  }

  void pauseTrack() {
    flutterSoundPlayer.pausePlayer();
    isPausingState = true;
    // we update the button play/pause
    createNotification();
  }

  void resumeTrack() {
    flutterSoundPlayer.resumePlayer();
    isPausingState = false;
    openAudioSession();
    // we update the button play/pause
    createNotification();
  }

  void gotoSeekPosition(Duration seekPosition) {
    flutterSoundPlayer.seekToPlayer(seekPosition);
    // We update the progress in notification:
    p = seekPosition;
    AwesomeNotifications().cancel(10);
    createNotification();
  }

  Future<TrackEntity> getNextTrack(int plusMinusOne, TrackEntity currentTrack) async {
    PlaylistsBloc playlistsBloc = BlocProvider.of<PlaylistsBloc>(myGlobals.scaffoldKey.currentContext!);
    List<TrackEntity> tracks = playlistsBloc.state.tracks;

    // we get the current list index based on current track id
    int index = tracks.indexWhere((element) => element.id == currentTrack.id);

    // We in- or decrease list index based on parameter
    index += plusMinusOne;

    // we prevent exception for index == -1 && index bigger than last index (out of range) and play previous/next track.
    if (index > -1 && index < tracks.length) {
      // we set new track based on decreased index
      TrackEntity track = tracks[index];
      String filePath = track.file.path;
      if (await File(filePath).exists()) {
        return track;
      } else {
        stopTrack();
        return TrackEntity.empty();
      }
    } else {
      return currentTrack;
    }
  }

/*

  // This method handles behaviour of player at end of track
  startPositionMonitoring() {
    bool hasStoppedChanging = false;
    TracklistCubit tracklistCubit = BlocProvider.of<TracklistCubit>(myGlobals.scaffoldKey.currentContext!);
    List<TrackEntity> tracks = tracklistCubit.state;
    final continuousPlaybackModeCubit =
    BlocProvider.of<ContinuousPlaybackModeCubit>(myGlobals.scaffoldKey.currentContext!);
    final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(myGlobals.scaffoldKey.currentContext!);
    final trackDurationCubit = BlocProvider.of<TrackDurationCubit>(myGlobals.scaffoldKey.currentContext!);

    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (unformatedDuration(trackDurationCubit.state) - 1500 <
          unformatedDuration(trackPositionCubit.state)) {
        hasStoppedChanging = true;
        timer.cancel();
        if (hasStoppedChanging == true) {
          if (continuousPlaybackModeCubit.state) {
            BlocProvider.of<PlayerControlsBloc>(myGlobals.scaffoldKey.currentContext!).add(NextButtonPressed());
            // Delay -> ensure timer starts when when new track duration is known
            Future.delayed(const Duration(milliseconds: 2000),
                startPositionMonitoring());
          } else if (isLoopModeCubit.state) {
            // we need current index in case user sorted or filtered the list
            int index =
            tracks.indexWhere((element) => element.id == selectedId);
            playTrack2(tracks[index]);
            startPositionMonitoring();
          } else {
            BlocProvider.of<PlayerControlsBloc>(myGlobals.scaffoldKey.currentContext!).add(InitialPlayerControls());
            cancelNotification();
          }
        }
      } else if (selectedId == -1) {
        timer.cancel();
      }
    });
  }

*/

}
