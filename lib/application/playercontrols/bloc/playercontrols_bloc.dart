import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

import '../../../core/globals.dart';
import '../../../core/notifications/create_notification.dart';
import '../../../injection.dart';
import '../../../core/player/audiohandler.dart';

part 'playercontrols_event.dart';
part 'playercontrols_state.dart';

class PlayerControlsBloc
    extends Bloc<PlayerControlsEvent, PlayerControlsState> {
  PlayerControlsBloc() : super(PlayerControlsState.initial()) {
    late BuildContext contextBloc;

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
      contextBloc = event.context;
      // player controls visible and audioHandler plays track
      if (event.track != state.track) {
        // play new selected track
        emit(state.copyWith(
          track: event.track,
          isPausing: false,
          height: 200,
        ));
        sl<MyAudioHandler>().playTrack(event.track, event.context);
      } else {
        // same track: player controls not visible and audioHandler stops track
        emit(state.copyWith(
          track: TrackEntity.empty().copyWith(id: 0),
          isPausing: false,
          height: 0,
        ));
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

    // For skip next or previous, this track will be played.
    // But if user changes playlist and then skip, then first track of new list will be played.
    // And if new playlist is empty (so we get em empty track), playing track keeps playing and notification is created
    on<NextButtonPressed>((event, emit) async {
      contextBloc = event.context;
      // check if event.mounted: necessary for notification after list was changed
      //if (event.context.mounted) {
      TrackEntity track = await sl<MyAudioHandler>()
          .getNextTrackAndPlay(1, state.track, event.context);

      if (track == TrackEntity.empty()) {
        // current playlist is empty
        createNotificationListViewEmpty();
      } else {
        emit(PlayerControlsState(
          track: track,
          isPausing: false,
          height: 200,
          loopMode: state.loopMode,
        ));
      }
      //}
    });

    on<NextButtonInNotificationPressed>((event, emit) async {
      add(NextButtonPressed(context: contextBloc));
    });

    on<PreviousButtonPressed>((event, emit) async {
      contextBloc = event.context;
      //if (event.context.mounted) {
      TrackEntity track = await sl<MyAudioHandler>()
          .getNextTrackAndPlay(-1, state.track, event.context);
      if (track == TrackEntity.empty()) {
        createNotificationListViewEmpty();
      } else {
        emit(PlayerControlsState(
          track: track,
          isPausing: false,
          height: 200,
          loopMode: state.loopMode,
        ));
      }
      //}
    });

    on<PreviousButtonInNotificationPressed>((event, emit) async {
      add(PreviousButtonPressed(context: contextBloc));
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
