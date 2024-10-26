import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../core/helpers/animate_to_index.dart';

class SkipToNextOrPrevious extends StatelessWidget {
  const SkipToNextOrPrevious({
    super.key,
    required this.observerController,
    required this.value,
  });

  final ListObserverController observerController;

  /// 0 = prev, 1 = next
  final int value;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        value == 1
            ? BlocProvider.of<PlayerControlsBloc>(context)
                .add(NextButtonPressed(context: context))
            : BlocProvider.of<PlayerControlsBloc>(context)
                .add(PreviousButtonPressed(context: context));
        gotoItem(value == 1 ? 0.0 : 144.0, observerController, context);
      },
      icon: Icon(
        value == 1 ? Icons.skip_next_rounded : Icons.skip_previous_rounded,
        color: const Color(0xFF202531),
      ),
      iconSize: 36,
    );
  }
}
