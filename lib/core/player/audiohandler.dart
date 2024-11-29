import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

import 'package:orangejam/services/audio_session.dart';
import 'package:orangejam/injection.dart' as di;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import '../../application/playlists/playlists_bloc.dart';
import '../../domain/entities/track_entity.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../globals.dart';
import '../notifications/create_notification.dart';

class MyAudioHandler {
  final BuildContext context;
  MyAudioHandler(this.context);

  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();

  /// track with id 0 has impact on notification update
  TrackEntity currentTrack = TrackEntity.empty().copyWith(id: 0);
  int id = 0; // this will be the currentTrack.id
  bool isPausingState = false;
  Duration currentPosition = Duration.zero;

  void openAudioSession() {
    di.sl<MyAudioSession>().audioSession();
  }

  /// NOTIFICATION ///
  void cancelNotification() {
    AwesomeNotifications().cancel(10);
  }

  /// Only iOS
  Future<TrackEntity> getFilePathForTrackIos(TrackEntity track) async {
    // invokeMethod creates a copy of the media item in iOS temp directory and returns only the generated file name (UUID)
    final String fileName = await platform
        .invokeMethod('getTempFilePath', {'assetUrl': track.filePath});
    // Flutter gets the temp directory in iOS
    final Directory appTempDir = await getTemporaryDirectory();
    final String appTempDirPath = appTempDir.path;
    // We build the full path of the file that was created by invokeMethod
    final String filePath = p.join(appTempDirPath, fileName);
    // We create a copy of the track to be played with a path that flutter_sound can access
    final TrackEntity iosTrack = track.copyWith(filePath: filePath);
    return iosTrack;
  }

  /// PLAYER CONTROLS ///
  void playTrack(TrackEntity track) async {
    currentTrack = track;
    id = currentTrack.id;

    final trackPositionCubit = context.read<TrackPositionCubit>();
    final trackDurationCubit = context.read<TrackDurationCubit>();

    currentPosition = Duration.zero;
    isPausingState = false;

    if (Platform.isIOS) {
      // We need the path to the generated file in temp directory
      final TrackEntity tempTrack = await getFilePathForTrackIos(track);
      final String filePath = tempTrack.filePath;
      final TrackEntity iosTrack = currentTrack.copyWith(filePath: filePath);
      currentTrack = iosTrack;
    }

    flutterSoundPlayer.startPlayer(
      fromURI: currentTrack.filePath,
      whenFinished: () => _handleTrackFinished(),
    );
    openAudioSession();
    createNotification(currentTrack, isPausingState, currentPosition);

    // Update progressbar in notification and player controls
    flutterSoundPlayer.onProgress?.listen((event) {
      currentPosition = event.position;
      trackDurationCubit.setDuration(event.duration);
      trackPositionCubit.setPosition(event.position);
    });
  }

  void _handleTrackFinished() async {
    final automaticPlaybackCubit = context.read<AutomaticPlaybackCubit>();
    final playerControlsBloc = context.read<PlayerControlsBloc>();
    if (playerControlsBloc.state.loopMode) {
      // Loop mode prevails: play same track again
      playTrack(currentTrack);
    } else if (automaticPlaybackCubit.state) {
      // no loop mode so we play next track: event is sent to bloc for UI update and the bloc will call method getNextTrackToPlayAndPlay() below
      sl<PlayerControlsBloc>().add(NextButtonPressed());
    } else {
      // no loop mode and no automatic playback: player just stops. Event is sent to bloc for UI update
      sl<PlayerControlsBloc>().add(InitialPlayerControls());
      cancelNotification();
    }
  }

  void stopTrack() {
    flutterSoundPlayer.stopPlayer();
    currentTrack = TrackEntity.empty().copyWith(id: 0);
    id = 0;
    cancelNotification();
  }

  void pauseTrack() {
    flutterSoundPlayer.pausePlayer();
    isPausingState = true;
    // we update the button play/pause
    createNotification(currentTrack, isPausingState, currentPosition);
  }

  void resumeTrack() {
    flutterSoundPlayer.resumePlayer();
    isPausingState = false;
    openAudioSession();
    // we update the button play/pause
    createNotification(currentTrack, isPausingState, currentPosition);
  }

  void gotoSeekPosition(Duration seekPosition) {
    flutterSoundPlayer.seekToPlayer(seekPosition);
    // We update the progress in notification:
    currentPosition = seekPosition;
    cancelNotification();
    createNotification(currentTrack, isPausingState, currentPosition);
  }

  Future<TrackEntity> getNextTrackAndPlay(
      int direction, TrackEntity currentTrackFromState) async {
    final tracks = context.read<PlaylistsBloc>().state.tracks;

    // we get the current list index based on current track
    int index = tracks.indexOf(
        currentTrackFromState); //tracks.indexWhere((element) => element.id == currentTrackFromState.id);

    // We in- or decrease list index based on parameter
    index += direction;

    // we prevent out of range exception for index == -1 or index bigger than last index
    if (index > -1 && index < tracks.length) {
      final TrackEntity track = tracks[index];

      if (Platform.isAndroid) {
        final filePath = track.filePath;
        if (await File(filePath).exists()) {
          playTrack(track);
          return track;
        } else {
          _showTrackNotFoundSnackBar(track);
          return TrackEntity.empty();
        }
      } else {
        playTrack(track);
        return track;
      }
    } else {
      // Here user skips -after last or before first- list item: app will play the 1st track of the playlist.
      if (tracks.isNotEmpty) {
        final track = tracks[0];
        playTrack(track);
        return track;
      } else {
        // Here user selected a different playlist:
        // If this playlist is empty, empty track is returned and player will do nothing: current playback continues.
        return TrackEntity.empty();
      }
    }
  }

  void _showTrackNotFoundSnackBar(TrackEntity track) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(S
              .of(context)
              .listItemSlidable_upsTheFileTrackfilepathWasNotFound(
                  track.filePath)),
        ),
      );
    }
  }
}
