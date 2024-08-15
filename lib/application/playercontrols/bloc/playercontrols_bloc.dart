import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

import '../../../injection.dart';
import '../../../core/player/audiohandler.dart';

part 'playercontrols_event.dart';
part 'playercontrols_state.dart';

class PlayerControlsBloc
    extends Bloc<PlayerControlsEvent, PlayerControlsState> {
  PlayerControlsBloc() : super(PlayerControlsState.initial()) {

    on<InitialPlayerControls>((event, emit) {
      emit(state.copyWith(
          track: TrackEntity.empty().copyWith(id: 0),
          isPausing: false,
          height: 0));
    });

    on<TrackItemPressed>((event, emit) {
      if (event.track != state.track) {
        // play new selected track
        emit(state.copyWith(
            track: event.track,
            isPausing: false,
            height: 200));
        sl<MyAudioHandler>().playTrack(event.track);
      } else {
        // stop current track
        emit(state.copyWith(
            track: TrackEntity.empty().copyWith(id: 0),
            isPausing: false,
            height: 0));
        sl<MyAudioHandler>().stopTrack();
      }
    });

    on<StopButtonPressed>((event, emit) {
        // This is used by the notification only
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

    // Following event is called when other app starts audio. The event just update UI.
    // Logic: Audio is paused by audioSession.
    on<PauseFromAudioSession>((event, emit) {
        emit(state.copyWith(isPausing: true));
    });

    on<NextButtonPressed>((event, emit) async {
      await sl<MyAudioHandler>().getNextTrack(1, state.track).then((value) {
        if(value.id != 0){
          emit(PlayerControlsState(
              track: value, isPausing: false, height: 200));
          sl<MyAudioHandler>().playTrack(value);
        }
      });
    });

    on<PreviousButtonPressed>((event, emit) async {
      await sl<MyAudioHandler>().getNextTrack(-1, state.track).then((value) {
        if(value.id != 0){
          sl<MyAudioHandler>().playTrack(value);
          emit(PlayerControlsState(
              track: value, isPausing: false, height: 200));
        }
      });
    });

    on<LoopButtonPressed>((event, emit) {});

    on<ContinuousButtonPressed>((event, emit) {});

    on<ShowHideControlsButtonPressed>((event, emit) {
      emit(state.copyWith(height: event.height));
    });

  }
}
