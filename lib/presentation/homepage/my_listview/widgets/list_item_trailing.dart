import 'package:flutter/material.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/playercontrols/bloc/playercontrols_bloc.dart';

// Hervorhebung des current tracks mit Animation
class ListItemTrailing extends StatelessWidget {
  final int id;
  final int? currentId;

  const ListItemTrailing({
    super.key,
    required this.id,
    required this.currentId,
  });

  @override
  Widget build(BuildContext context) {
    if (currentId != id) {
      return const Icon(null);
    } else {
      return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
        builder: (context, state) {
          return state.isPausing
              ? AudioWave(
                  height: 42,
                  width: 48,
                  bars: [
                    AudioWaveBar(
                      heightFactor: 0.6,
                      color: const Color(0xFF202531).withOpacity(0.0),
                    ),
                    AudioWaveBar(
                      heightFactor: 0.6,
                      color: const Color(0xFF202531),
                    ),
                    AudioWaveBar(
                      heightFactor: 0.6,
                      color: const Color(0xFF202531),
                    ),
                    AudioWaveBar(
                      heightFactor: 0.6,
                      color: const Color(0xFF202531).withOpacity(0.0),
                    ),
                  ],
                )
              : AudioWave(
                  height: 64,
                  width: 36,
                  beatRate: const Duration(milliseconds: 500),
                  bars: [
                    AudioWaveBar(
                      heightFactor: 0.6,
                      color: const Color(0xFF202531),
                    ),
                    AudioWaveBar(
                      heightFactor: 0.4,
                      color: const Color(0xFF202531),
                    ),
                    AudioWaveBar(
                      heightFactor: 0.2,
                      color: const Color(0xFF202531),
                    ),
                  ],
                );
        },
      );
    }
  }
}
