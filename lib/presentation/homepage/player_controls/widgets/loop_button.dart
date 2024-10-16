import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../injection.dart' as di;

import '../../../../generated/l10n.dart';

class LoopButton extends StatelessWidget {
  const LoopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            di.sl<PlayerControlsBloc>().add(LoopButtonPressed());
            state.loopMode
                ? {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(S.of(context).loopButton_LoopPlaybackIsOff),
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                      ),
                    ),
                  }
                : {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(S.of(context).loopButton_LoopPlaybackIsOn),
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                      ),
                    ),
                  };
          },
          icon: state.loopMode
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
