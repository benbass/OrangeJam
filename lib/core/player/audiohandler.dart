import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

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
  FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();

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
  void playTrack(TrackEntity track, BuildContext context) {
    /// The following 2 vars are needed for the whenFinished function
    final automaticPlaybackCubit =
        BlocProvider.of<AutomaticPlaybackCubit>(context);
    final playerControlsBloc = BlocProvider.of<PlayerControlsBloc>(context);

    ///

    final trackPositionCubit = BlocProvider.of<TrackPositionCubit>(context);
    final trackDurationCubit = BlocProvider.of<TrackDurationCubit>(context);

    p = Duration.zero;
    isPausingState = false;
    currentTrack = track;
    flutterSoundPlayer.startPlayer(
      fromURI: track.filePath,

      /// Logic for loop song and automatic playback!!!
      whenFinished: () async {
        if (playerControlsBloc.state.loopMode && automaticPlaybackCubit.state) {
          // Loop mode prevails: play same track again
          playTrack(currentTrack, context);
        } else if (playerControlsBloc.state.loopMode &&
            !automaticPlaybackCubit.state) {
          // Loop mode prevails: play same track again
          playTrack(currentTrack, context);
        } else if (automaticPlaybackCubit.state &&
            !playerControlsBloc.state.loopMode) {
          // no loop mode so we play next track
          sl<PlayerControlsBloc>().add(NextButtonPressed(context: context));
        } else {
          // no loop mode and no automatic playback: we stop the player
          sl<PlayerControlsBloc>().add(InitialPlayerControls());
          cancelNotification();
        }
      },
    );
    openAudioSession();
    createNotification(track, isPausingState, p);

    // Update progressbar in notification and player controls
    flutterSoundPlayer.onProgress?.listen((event) {
      p = event.position;
      trackDurationCubit.setDuration(event.duration);
      trackPositionCubit.setPosition(event.position);
    });
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

  Future<TrackEntity> getNextTrackToPlay(
    int plusMinusOne,
    TrackEntity currentTrack,
    BuildContext context,
  ) async {
    List<TrackEntity> tracks =
        BlocProvider.of<PlaylistsBloc>(context).state.tracks;
    // we get the current list index based on current track id
    int index = tracks.indexWhere((element) => element.id == currentTrack.id);

    // We in- or decrease list index based on parameter
    index += plusMinusOne;

    // we prevent out of range exception for index == -1 && index bigger than last index and play previous/next track.
    if (index > -1 && index < tracks.length) {
      // we set new track based on decreased index
      TrackEntity track = tracks[index];
      String filePath = track.filePath;
      if (await File(filePath).exists()) {
        return track;
      } else {
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
        return TrackEntity.empty();
      }
    } else {
      // Here user selected a different playlist: app will play the 1st track of this playlist.
      // If this playlist is empty, player will stop.
      if (BlocProvider.of<PlaylistsBloc>(context).state.tracks.isNotEmpty) {
        return BlocProvider.of<PlaylistsBloc>(context).state.tracks[0];
      } else {
        return TrackEntity.empty();
      }
    }
  }
}
