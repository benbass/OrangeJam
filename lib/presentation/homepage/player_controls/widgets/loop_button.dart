import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../../../application/playlists/automatic_playback_cubit.dart';
import '../../../../generated/l10n.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
    required this.isLoopModeCubit,
  });

  final LoopModeCubit isLoopModeCubit;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AutomaticPlaybackCubit>(context);

    return BlocBuilder<LoopModeCubit, bool>(
      builder: (context, loopMode) {
        return IconButton(
          onPressed: () {
            loopMode
                ? isLoopModeCubit.setLoopMode(false)
                : isLoopModeCubit.setLoopMode(true);
            loopMode
                ? {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).loopButton_LoopPlaybackIsOff),
                  duration: const Duration(
                    milliseconds: 500,
                  ),
                ),
              ),
            }
                : {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).loopButton_LoopPlaybackIsOn),
                  duration: const Duration(
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