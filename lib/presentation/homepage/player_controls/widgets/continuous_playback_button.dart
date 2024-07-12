import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../../../generated/l10n.dart';

class ContinuousPlayback extends StatelessWidget {
  const ContinuousPlayback({
    super.key,
    required this.isLoopModeCubit,
    required this.continuousPlaybackModeCubit,
  });

  final LoopModeCubit isLoopModeCubit;
  final ContinuousPlaybackModeCubit continuousPlaybackModeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContinuousPlaybackModeCubit, bool>(
      builder: (context, continuousPlaybackMode) {
        return IconButton(
          onPressed: () {
            if (isLoopModeCubit.state == true) {
              isLoopModeCubit.setLoopMode(false);
            }
            continuousPlaybackMode
                ? continuousPlaybackModeCubit
                .setContinuousPlaybackMode(false)
                : continuousPlaybackModeCubit
                .setContinuousPlaybackMode(true);
            continuousPlaybackMode
                ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).continuousPlaybackButton_ContinuousPlaybackIsOff),
                duration: const Duration(
                  milliseconds: 500,
                ),
              ),
            )
                : ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).continuousPlaybackButton_ContinuousPlaybackIsOn),
                duration: const Duration(
                  milliseconds: 500,
                ),
              ),
            );
          },
          icon: continuousPlaybackMode
              ? const Icon(
            Icons.loop_rounded,
            color: Color(0xFF202531),
          )
              : Icon(
            Icons.loop_rounded,
            color: const Color(0xFF202531).withOpacity(0.4),
          ),
          iconSize: 22,
        );
      },
    );
  }
}