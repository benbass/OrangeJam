import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/loop_mode_cubit.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
    required this.continuousPlaybackModeCubit,
    required this.isLoopModeCubit,
  });

  final ContinuousPlaybackModeCubit continuousPlaybackModeCubit;
  final LoopModeCubit isLoopModeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopModeCubit, bool>(
      builder: (context, loopMode) {
        return IconButton(
          onPressed: () {
            continuousPlaybackModeCubit
                .setContinuousPlaybackMode(false);
            loopMode
                ? isLoopModeCubit.setLoopMode(false)
                : isLoopModeCubit.setLoopMode(true);
            loopMode
                ? {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Loop playback is off"),
                  duration: Duration(
                    milliseconds: 500,
                  ),
                ),
              ),
            }
                : {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Loop playback is on"),
                  duration: Duration(
                    milliseconds: 500,
                  ),
                ),
              ),
            };
          },
          icon: loopMode
              ? const Icon(
            Icons.repeat_one_rounded,
            color: Color(0xFF202531),
          )
              : Icon(
            Icons.repeat_one_rounded,
            color: const Color(0xFF202531).withOpacity(0.4),
          ),
          iconSize: 22,
        );
      },
    );
  }
}