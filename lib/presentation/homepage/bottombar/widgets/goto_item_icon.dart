import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/core/player/audiohandler.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../../application/listview/ui/is_scroll_reverse_cubit.dart';
import '../../../../application/listview/ui/is_scrolling_cubit.dart';
import '../../../../core/manipulate_list/animate_to_index.dart';
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
    return BlocBuilder<IsScrollingCubit, bool?>(
        builder: (context, scrollingState) {
      return BlocBuilder<IsScrollReverseCubit, bool?>(
          builder: (context, reverseState) {
        return IconButton(
          onPressed: () => gotoItem(72.0, observerController),
          icon: scrollingState! && sl<MyAudioHandler>().currentTrack.id != 0
              ? Transform.flip(
                      flipY: reverseState!,
                      child: Image.asset(
                        "assets/scroll.png",
                        color: const Color(0xFFCBD4C2),
                        height: 18,
                      ),
                    )
              : const Icon(null),
        );
      });
    });
  }
}
