import 'package:flutter/material.dart';

import '../../../../domain/entities/track_entity.dart';

class TrackInfoText extends StatelessWidget {
  const TrackInfoText({
    super.key,
    required this.track,
    required this.themeData,
  });

  final TrackEntity track;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 2,
            ),
            SizedBox(
              child: Text(
                track.trackName ?? "",
                overflow: TextOverflow.ellipsis,
                style: themeData.textTheme.bodyLarge?.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF202531),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              child: Text(
                track.trackArtistNames ?? "",
                overflow: TextOverflow.ellipsis,
                style: themeData.textTheme.bodyLarge?.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF202531),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}