import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection.dart' as di;

import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';

class Stop extends StatelessWidget {
  const Stop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            di.sl<PlayerControlsBloc>().add(StopButtonPressed());
          },
          icon: const Icon(
            Icons.stop_rounded,
            color: Color(0xFF202531),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: 44,
        );
      },
    );
  }
}
