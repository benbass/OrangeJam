// This method helps handling behaviour of player at end of track
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/core/player/audiohandler.dart';

import '../../../../../injection.dart';
import '../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../application/playercontrols/cubits/track_position_cubit.dart';
import '../helpers/format_duration.dart';
import '../globals.dart';

startPositionMonitoring() {
  bool hasStoppedChanging = false;
  final trackPositionCubit = BlocProvider.of<TrackPositionCubit>(globalScaffoldKey.scaffoldKey.currentContext!);
  final trackDurationCubit = BlocProvider.of<TrackDurationCubit>(globalScaffoldKey.scaffoldKey.currentContext!);
  final continuousPlaybackModeCubit =
  BlocProvider.of<ContinuousPlaybackModeCubit>(globalScaffoldKey.scaffoldKey.currentContext!);
  final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(globalScaffoldKey.scaffoldKey.currentContext!);
  final playerControlsBloc = BlocProvider.of<PlayerControlsBloc>(globalScaffoldKey.scaffoldKey.currentContext!);

  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
    if (unformatedDuration(trackDurationCubit.state) - 1500 <
        unformatedDuration(trackPositionCubit.state!)) {
      hasStoppedChanging = true;
      timer.cancel();
      if (hasStoppedChanging == true) {
        if (continuousPlaybackModeCubit.state) {
          sl<PlayerControlsBloc>().add(NextButtonPressed());
          // Delay -> ensure timer starts when new track duration is known
          Future.delayed(const Duration(milliseconds: 2000),
              startPositionMonitoring());
        } else if (isLoopModeCubit.state) {
          sl<MyAudioHandler>().playTrack(playerControlsBloc.state.track);
          startPositionMonitoring();
        } else {
          sl<PlayerControlsBloc>().add(InitialPlayerControls());
          sl<MyAudioHandler>().cancelNotification();
        }
      }
    } else if (playerControlsBloc.state.track.id == 0) {
      timer.cancel();
    }
  });

}