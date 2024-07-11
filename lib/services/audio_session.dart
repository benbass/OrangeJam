import 'package:audio_session/audio_session.dart';
import 'package:orange_player/core/audiohandler.dart';
import 'package:orange_player/injection.dart' as di;

import '../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../core/create_notification.dart';


class MyAudioSession {

  // Communicate with OS and pause playback when other app is playing sound
  void handleInterruptions(
      AudioSession audioSession) async {
    bool playInterrupted = false;

    // Handle earphones unplugging
    audioSession.becomingNoisyEventStream.listen((_) {
      di.sl<MyAudioHandler>().pauseTrack();
      di.sl<PlayerControlsBloc>().add(PauseFromAudioSession());
    });

    if (di.sl<MyAudioHandler>().flutterSoundPlayer.isPlaying) {
      playInterrupted = false;
      await audioSession.setActive(true);
    }

    // Handle events
    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
                  di.sl<MyAudioHandler>().flutterSoundPlayer.setVolume(0.3);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            var audioHandler = di.sl<MyAudioHandler>();
            createNotification(audioHandler.selectedId, audioHandler.currentTrack, audioHandler.isPausingState, audioHandler.p);
            di.sl<PlayerControlsBloc>().add(PauseFromAudioSession());
            break;
          case AudioInterruptionType.unknown:
            if (di.sl<MyAudioHandler>().flutterSoundPlayer.isPlaying) {
              di.sl<MyAudioHandler>().pauseTrack();
              di.sl<PlayerControlsBloc>().add(PauseFromAudioSession());
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            di.sl<MyAudioHandler>().flutterSoundPlayer.setVolume(1);
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) {
              di.sl<MyAudioHandler>().resumeTrack();
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            if (playInterrupted) {
              di.sl<MyAudioHandler>().resumeTrack();
            }
            playInterrupted = false;
            break;
        }
      }
    });

    // A stream emitting events whenever devices are added or removed to the set of available devices.
    audioSession.devicesChangedEventStream.listen((event) {
      /*
      print('Devices added: ${event.devicesAdded}');
      print('Devices removed: ${event.devicesRemoved}');
      */
    });
  }

  void audioSession() {
    Future<AudioSession> futureSession = createAudioSession();
    futureSession.then((value) => handleInterruptions(value));
  }

  Future<AudioSession> createAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await session.setActive(true);
    return session;
  }
}
