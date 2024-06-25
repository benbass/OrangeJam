import 'package:flutter/material.dart';

import '../../../../domain/entities/track_entity.dart';

class ItemLeading extends StatelessWidget {
  const ItemLeading({
    super.key,
    required this.track,
  });

  final TrackEntity track;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(35),
        child: track.albumArt == null
            ? const Image(
          image: AssetImage(
            "assets/album-placeholder.png",
          ),
          fit: BoxFit.fill,
        )
            : Image(
          image: MemoryImage(track.albumArt!),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}