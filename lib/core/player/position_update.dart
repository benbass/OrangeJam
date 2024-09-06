// This is not used anymore!!!!


import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../application/playlists/automatic_playback_cubit.dart';
import '../../injection.dart';
import '../globals.dart';
import 'audiohandler.dart';

class PositionUpdate {
  Duration currentPosition = Duration.zero;
  Duration lastPosition = Duration.zero;
  Timer? positionCheckTimer;
  bool hasStoppedChanging = false;

  startPositionCheckTimer() {
    final trackPositionCubit = BlocProvider.of<TrackPositionCubit>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    final automaticPlaybackCubit =
    BlocProvider.of<AutomaticPlaybackCubit>(globalScaffoldKey.scaffoldKey.currentContext!);
    final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    final playerControlsBloc = BlocProvider.of<PlayerControlsBloc>(
        globalScaffoldKey.scaffoldKey.currentContext!);

    positionCheckTimer?.cancel();

    positionCheckTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      updatePosition(trackPositionCubit.state!);
      if (currentPosition == lastPosition) {
        // The logic for this app
        if (!sl<MyAudioHandler>().flutterSoundPlayer.isPaused) {
          hasStoppedChanging = true;
          timer.cancel();
          //print('Position has not changed for 1 second');
          if (hasStoppedChanging == true) {
            if (isLoopModeCubit.state && automaticPlaybackCubit.state) {
              sl<MyAudioHandler>().playTrack(playerControlsBloc.state.track);
            }
            else if (isLoopModeCubit.state && !automaticPlaybackCubit.state) {
              sl<MyAudioHandler>().playTrack(playerControlsBloc.state.track);
            }
            else if (automaticPlaybackCubit.state && !isLoopModeCubit.state) {
              sl<PlayerControlsBloc>().add(NextButtonPressed());
            } else {
              positionCheckTimer?.cancel();
              sl<PlayerControlsBloc>().add(InitialPlayerControls());
              sl<MyAudioHandler>().cancelNotification();
            }
          }
        }
      } else if (playerControlsBloc.state.track.id == 0) {
        timer.cancel();
      }
      // End of the logic for this app
      else {
        lastPosition = currentPosition;
      }
    });
  }

  void updatePosition(Duration newPosition) {
    currentPosition = newPosition;
  }
}
