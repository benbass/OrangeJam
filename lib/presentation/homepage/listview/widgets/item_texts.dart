import 'package:flutter/material.dart';

import '../../../../domain/entities/track_entity.dart';

class ItemTexts extends StatelessWidget {
  const ItemTexts({
    super.key,
    required this.track,
    required this.themeData,
    required this.textColor,
  });

  final TrackEntity track;
  final ThemeData themeData;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 240,
              child: Text(
                track.trackName ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: themeData.textTheme.bodyMedium!
                    .copyWith(color: textColor),
              ),
            ),
            SizedBox(
              child: Text(
                track.trackArtistNames ?? "",
                style: themeData.textTheme.bodySmall!
                    .copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}