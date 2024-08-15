import 'package:flutter/material.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

class ContainerInfoImage extends StatelessWidget {
  final TrackEntity currentTrack;
  const ContainerInfoImage({
    super.key,
    required this.currentTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        image: currentTrack.albumArt != null
            ? DecorationImage(
                image: MemoryImage(currentTrack.albumArt!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage("assets/album-placeholder.png"),
                fit: BoxFit.cover,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),




    );
  }
}
