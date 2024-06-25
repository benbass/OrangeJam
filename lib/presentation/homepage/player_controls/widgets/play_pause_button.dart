import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection.dart' as di;

import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';

class PlayPause extends StatelessWidget {
  const PlayPause({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            di.sl<PlayerControlsBloc>().add(PausePlayButtonPressed());
          },
          icon: !state.isPausing
              ? const Icon(
                  Icons.pause_rounded,
                  color: Color(0xFF202531),
                )
              : const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF202531),
                ),
          iconSize: 64,
        );
      },
    );
  }
}
