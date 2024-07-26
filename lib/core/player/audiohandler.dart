import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:orange_player/application/playlists/playlists_bloc.dart';
import 'package:orange_player/application/playercontrols/cubits/track_duration_cubit.dart';
import 'package:orange_player/application/playercontrols/cubits/track_position_cubit.dart';

import 'package:orange_player/services/audio_session.dart';
import 'package:orange_player/injection.dart' as di;

import '../../domain/entities/track_entity.dart';
import '../notifications/create_notification.dart';
import '../globals.dart';

class MyAudioHandler {
  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
  TrackDurationCubit trackDurationCubit = TrackDurationCubit();
  TrackPositionCubit trackPositionCubit = TrackPositionCubit();

  /// we need the following vars with initial values for the notification handler at app start
  TrackEntity currentTrack = TrackEntity.empty().copyWith(id: 0);
  bool isPausingState = false;
  int selectedId = 0;
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
    selectedId = track.id;
    flutterSoundPlayer.startPlayer(fromURI: track.filePath);
    openAudioSession();
    createNotification(selectedId, currentTrack, isPausingState, p);
    // Update progressbar in notification
    flutterSoundPlayer.onProgress?.listen((event) {
      p = event.position;
    });
  }

  void stopTrack() {
    flutterSoundPlayer.stopPlayer();
    currentTrack = TrackEntity.empty().copyWith(id: 0);
    selectedId = 0;
    AwesomeNotifications().cancel(10);
  }

  void pauseTrack() {
    flutterSoundPlayer.pausePlayer();
    isPausingState = true;
    // we update the button play/pause
    createNotification(selectedId, currentTrack, isPausingState, p);
  }

  void resumeTrack() {
    flutterSoundPlayer.resumePlayer();
    isPausingState = false;
    openAudioSession();
    // we update the button play/pause
    createNotification(selectedId, currentTrack, isPausingState, p);
  }

  void gotoSeekPosition(Duration seekPosition) {
    flutterSoundPlayer.seekToPlayer(seekPosition);
    // We update the progress in notification:
    p = seekPosition;
    AwesomeNotifications().cancel(10);
    createNotification(selectedId, currentTrack, isPausingState, p);
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
