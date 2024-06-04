import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/my_listview/ui/is_scroll_reverse_cubit.dart';
import '../../../../application/my_listview/ui/is_scrolling_cubit.dart';

class GotoItemIcon extends StatelessWidget {
  const GotoItemIcon({
    super.key,
    required this.isScrollReverseCubit,
    required this.isScrollingCubit,
    required this.gotoItem,
  });

  final IsScrollReverseCubit isScrollReverseCubit;
  final IsScrollingCubit isScrollingCubit;
  final Function gotoItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsScrollingCubit, bool?>(
        builder: (context, scrollingState) {
      return BlocBuilder<IsScrollReverseCubit, bool?>(
          builder: (context, reverseState) {
        return IconButton(
          onPressed: () => gotoItem(72.0),
          icon: scrollingState!
              ? Transform.flip(
                      flipY: reverseState!,
                      child: Image.asset(
                        "assets/scroll.png",
                        color: const Color(0xFFCBD4C2),
                        height: 24,
                      ),
                    )
              : const Icon(null),
        );
      });
    });
  }
}
