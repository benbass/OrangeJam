import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:orangejam/core/helpers/get_current_index.dart';

import 'package:orangejam/services/audio_session.dart';
import 'package:orangejam/injection.dart' as di;

import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import '../../application/playlists/playlists_bloc.dart';
import '../../domain/entities/track_entity.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../notifications/create_notification.dart';

class MyAudioHandler {
  final BuildContext context;
  MyAudioHandler(this.context);

  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();

  /// track with id 0 has impact on notification update
  TrackEntity currentTrack = TrackEntity.empty().copyWith(id: 0);
  bool isPausingState = false;
  Duration currentPosition = Duration.zero;

  void openAudioSession() {
    di.sl<MyAudioSession>().audioSession();
  }

  /// NOTIFICATION ///
  void cancelNotification() {
    AwesomeNotifications().cancel(10);
  }

  /// PLAYER CONTROLS ///
  void playTrack(TrackEntity track) {
    final automaticPlaybackCubit = context.read<AutomaticPlaybackCubit>();
    final playerControlsBloc = context.read<PlayerControlsBloc>();
    final trackPositionCubit = context.read<TrackPositionCubit>();
    final trackDurationCubit = context.read<TrackDurationCubit>();

    currentPosition = Duration.zero;
    isPausingState = false;
    currentTrack = track;

    flutterSoundPlayer.startPlayer(
      fromURI: track.filePath,
      whenFinished: () => _handleTrackFinished(automaticPlaybackCubit, playerControlsBloc),
    );
    openAudioSession();
    createNotification(track, isPausingState, currentPosition);

    // Update progressbar in notification and player controls
    flutterSoundPlayer.onProgress?.listen((event) {
      currentPosition = event.position;
      trackDurationCubit.setDuration(event.duration);
      trackPositionCubit.setPosition(event.position);
    });
  }

  void _handleTrackFinished(AutomaticPlaybackCubit automaticPlaybackCubit, PlayerControlsBloc playerControlsBloc) async {
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
    AwesomeNotifications().cancel(10);
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
    AwesomeNotifications().cancel(10);
    createNotification(currentTrack, isPausingState, currentPosition);
  }

  Future<TrackEntity> getNextTrackAndPlay(
      int direction,
      TrackEntity currentTrack,
      ) async {
    final tracks = context.read<PlaylistsBloc>().state.tracks;
    // we get the current list index based on current track id
    var index = getIndex(context);

    // We in- or decrease list index based on parameter
    index += direction;

    // we prevent out of range exception for index == -1 or index bigger than last index
    if (index > -1 && index < tracks.length) {
      final track = tracks[index];
      final filePath = track.filePath;
      if (await File(filePath).exists()) {

          playTrack(track);

        return track;
      } else {

          _showTrackNotFoundSnackBar(track);

        return TrackEntity.empty();
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

