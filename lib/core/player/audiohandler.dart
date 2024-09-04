import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/core/player/position_update.dart';

import 'package:orangejam/services/audio_session.dart';
import 'package:orangejam/injection.dart' as di;

import '../../domain/entities/track_entity.dart';
import '../notifications/create_notification.dart';
import '../globals.dart';

class MyAudioHandler {
  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
  final PositionUpdate positionUpdate = PositionUpdate();

  /// we need the following vars with initial values for the notification handler at app start
  /// track id 0 is empty track
  TrackEntity currentTrack = TrackEntity.empty().copyWith(id: 0);
  bool isPausingState = false;
  ///

  void openAudioSession() {
    di.sl<MyAudioSession>().audioSession();
  }

  /// NOTIFICATION ///
  void cancelNotification() {
    AwesomeNotifications().cancel(10);
  }

  Duration p = Duration.zero;



  /// PLAYER CONTROLS ///
  void playTrack(TrackEntity track) {
    p = Duration.zero;
    isPausingState = false;
    currentTrack = track;
    flutterSoundPlayer.startPlayer(fromURI: track.filePath);
    openAudioSession();
    createNotification(track, isPausingState, p);

    // Update progressbar in notification
    flutterSoundPlayer.onProgress?.listen((event) {
      p = event.position;
    });

    // check position with timer for app's behaviour at end of playback
    // we delay to ensure that this track's trackPositionCubit.state != null and currentPosition != lastPosition ( in startPositionCheckTimer() )
    Future.delayed(const Duration(seconds: 1))
        .whenComplete(() =>
        positionUpdate.startPositionCheckTimer());
  }

  void stopTrack() {
    flutterSoundPlayer.stopPlayer();
    currentTrack = TrackEntity.empty().copyWith(id: 0);
    AwesomeNotifications().cancel(10);
    positionUpdate.positionCheckTimer?.cancel();
  }

  void pauseTrack() {
    flutterSoundPlayer.pausePlayer();
    isPausingState = true;
    // we update the button play/pause
    createNotification(currentTrack, isPausingState, p);
  }

  void resumeTrack() {
    flutterSoundPlayer.resumePlayer();
    isPausingState = false;
    openAudioSession();
    // we update the button play/pause
    createNotification(currentTrack, isPausingState, p);
  }

  void gotoSeekPosition(Duration seekPosition) {
    flutterSoundPlayer.seekToPlayer(seekPosition);
    // We update the progress in notification:
    p = seekPosition;
    AwesomeNotifications().cancel(10);
    createNotification(currentTrack, isPausingState, p);
  }

  Future<TrackEntity> getNextTrack(int plusMinusOne, TrackEntity currentTrack) async {
    PlaylistsBloc playlistsBloc = BlocProvider.of<PlaylistsBloc>(globalScaffoldKey.scaffoldKey.currentContext!);
    List<TrackEntity> tracks = playlistsBloc.state.tracks;

    // we get the current list index based on current track id
    int index = tracks.indexWhere((element) => element.id == currentTrack.id);

    // We in- or decrease list index based on parameter
    index += plusMinusOne;

    // we prevent exception for index == 0 && index bigger than last index (out of range) and play previous/next track.
    if (index > 0 && index < tracks.length) {
      // we set new track based on decreased index
      TrackEntity track = tracks[index];
      String filePath = track.filePath;
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

}
