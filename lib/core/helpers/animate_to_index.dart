import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'get_current_index.dart';

// this is used to jump to currently playing track in list
void gotoItem(double offset, ListObserverController observerController, BuildContext context ) {
  observerController.animateTo(
    alignment: 0,
    index: getIndex(context),
    offset: (_) => offset,
    isFixedHeight: true,
    padding: const EdgeInsets.only(bottom: 200),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );
}

