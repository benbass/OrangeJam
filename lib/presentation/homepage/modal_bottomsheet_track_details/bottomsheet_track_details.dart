import 'package:flutter/material.dart';

import '../../../domain/entities/track_entity.dart';
import 'widgets/container_info_image.dart';
import 'widgets/sizedbox_info_text.dart';

class BottomSheetTrackDetails extends StatelessWidget {
  const BottomSheetTrackDetails({
    super.key,
    required this.themeData,
    required this.track,
  });

  final ThemeData themeData;
  final TrackEntity track;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet(
        shape: const ContinuousRectangleBorder(),
        backgroundColor:
        themeData.bottomSheetTheme.backgroundColor,
        context: context,
        builder: (BuildContext context) =>
            OrientationBuilder(builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? SizedBox(
                height: 480,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 8.0),
                      child: ContainerInfoImage(
                          currentTrack: track),
                    ),
                    Expanded(
                      child: SizedBoxInfoText(
                        currentTrack: track,
                      ),
                    ),
                  ],
                ),
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: SizedBox(
                        width: 240,
                        child: ContainerInfoImage(
                          currentTrack: track,
                        )),
                  ),
                  Expanded(
                    child: SizedBoxInfoText(
                      currentTrack: track,
                    ),
                  ),
                ],
              );
              //buildColumnInfo();
            }),
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Color(0xFF202531),
      ),
      iconSize: 22,
    );
  }
}