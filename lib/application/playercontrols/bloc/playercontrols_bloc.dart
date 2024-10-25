import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

import '../../../core/globals.dart';
import '../../../injection.dart';
import '../../../core/player/audiohandler.dart';

part 'playercontrols_event.dart';
part 'playercontrols_state.dart';

class PlayerControlsBloc
    extends Bloc<PlayerControlsEvent, PlayerControlsState> {
  PlayerControlsBloc() : super(PlayerControlsState.initial()) {
    // Initial state: empty track -> player controls not visible
    on<InitialPlayerControls>((event, emit) {
      emit(state.copyWith(
        track: TrackEntity.empty().copyWith(id: 0),
        isPausing: false,
        height: 0,
        loopMode: false,
      ));
    });

    // track was pressed:
    on<TrackItemPressed>((event, emit) {
      // player controls visible and audioHandler plays track
      if (event.track != state.track) {
        // play new selected track
        emit(state.copyWith(track: event.track, isPausing: false, height: 200));
        sl<MyAudioHandler>().playTrack(event.track);
      } else {
        // same track: player controls not visible and audioHandler stops track
        emit(state.copyWith(
            track: TrackEntity.empty().copyWith(id: 0),
            isPausing: false,
            height: 0));
        sl<MyAudioHandler>().stopTrack();
      }
    });

    on<StopButtonPressed>((event, emit) {
      emit(state.copyWith(
          track: TrackEntity.empty().copyWith(id: 0),
          isPausing: false,
          height: 0));
      sl<MyAudioHandler>().stopTrack();
    });

    on<PausePlayButtonPressed>((event, emit) {
      if (state.isPausing == false) {
        emit(state.copyWith(isPausing: true));
        sl<MyAudioHandler>().pauseTrack();
      } else {
        emit(state.copyWith(isPausing: false));
        sl<MyAudioHandler>().resumeTrack();
      }
    });

    // Following event is called when other app starts audio. The event just updates UI.
    // Logic: Audio is paused by audioSession.
    on<PauseFromAudioSession>((event, emit) {
      emit(state.copyWith(isPausing: true));
    });

    on<NextButtonPressed>((event, emit) async {
      TrackEntity nextTrack = await sl<MyAudioHandler>().getNextTrack(1, state.track);
      //await sl<MyAudioHandler>().getNextTrack(1, state.track).then((value) {
        //if (nextTrack.id != 0) {
          emit(PlayerControlsState(
            track: nextTrack,
            isPausing: false,
            height: 200,
            loopMode: state.loopMode,
          ));
          sl<MyAudioHandler>().playTrack(nextTrack);
        //}
      //});
    });

    on<PreviousButtonPressed>((event, emit) async {
      TrackEntity previousTrack = await sl<MyAudioHandler>().getNextTrack(-1, state.track);
      //await sl<MyAudioHandler>().getNextTrack(-1, state.track).then((value) {
        //if (value.id != 0) {
          emit(PlayerControlsState(
            track: previousTrack,
            isPausing: false,
            height: 200,
            loopMode: state.loopMode,
          ));
          sl<MyAudioHandler>().playTrack(previousTrack);
        //}
      //});
    });

    on<LoopButtonPressed>((event, emit) {
      if (state.loopMode == true) {
        emit(state.copyWith(loopMode: false));
      } else {
        emit(state.copyWith(loopMode: true));
      }
    });

    // Update track info after metatag update: this event will be called only if updated track is currently playing track
    on<TrackMetaTagUpdated>((event, emit) {
      TrackEntity? track = trackBox.get(state.track.id);
      emit(state.copyWith(track: track));
    });

    // This event is triggered by the button on the right side of the bottomBar
    on<ShowHideControlsButtonPressed>((event, emit) {
      emit(state.copyWith(height: event.height));
    });
  }
}
