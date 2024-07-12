import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/playercontrols/bloc/playercontrols_bloc.dart';

import '../../../../core/player/audiohandler.dart';
import '../../../../injection.dart';

class ShowHidePlayerControls extends StatelessWidget {
  const ShowHidePlayerControls({super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Show player controls
        BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
          builder: (context, state) {
            if (sl<MyAudioHandler>().selectedId != 0) {
              return IconButton(
                onPressed: () {
                  state.height > 0
                      ? BlocProvider.of<PlayerControlsBloc>(context)
                          .add(ShowHideControlsButtonPressed(height: 0))
                      : BlocProvider.of<PlayerControlsBloc>(context)
                          .add(ShowHideControlsButtonPressed(height: 200));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Transform.flip(
                  flipY: state.height == 200,
                  child: Image.asset(
                    "assets/arrow.png",
                    color: const Color(0xFFCBD4C2),
                    height: 40,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
