import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/core/player/audiohandler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../../../application/listview/ui/is_scrolling_cubit.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../core/helpers/animate_to_index.dart';
import '../../../../injection.dart';

class GotoItemIcon extends StatelessWidget {
  const GotoItemIcon({
    super.key,
    required this.isScrollReverseCubit,
    required this.isScrollingCubit,
    required this.observerController,
  });

  final IsScrollReverseCubit isScrollReverseCubit;
  final IsScrollingCubit isScrollingCubit;
  final ListObserverController observerController;

  /// This widget allows to jump to current track after user scrolled the list
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
          builder: (context, state) {
            if (state.track.id != 0) {
              // button is shown only if a track is playing && list is scrolled
              return BlocBuilder<IsScrollingCubit, bool?>(
                  builder: (context, scrollingState) {
                return BlocBuilder<IsScrollReverseCubit, bool?>(
                    builder: (context, reverseState) {
                  return IconButton(
                    onPressed: () => gotoItem(72.0, observerController, context),
                    icon: scrollingState! &&
                            sl<MyAudioHandler>().currentTrack.id != 0
                        ? Transform.flip(
                            flipY: reverseState!,
                            child: const Icon(
                              Icons.move_up,
                              size: 20,
                            ),
                          )
                        : const Icon(null),
                  );
                });
              });
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
