import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:path/path.dart';

import '../../../../core/format_duration.dart';

class SizedBoxInfoText extends StatelessWidget {
  final TrackEntity currentTrack;
  const SizedBoxInfoText({super.key, required this.currentTrack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Track: ",
                    style: TextStyle(
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: currentTrack.trackName,
                    style: const TextStyle(
                      color: Color(0xFF202531),
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Artist: ",
                    style: TextStyle(
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: currentTrack.trackArtistNames,
                    style: const TextStyle(
                      color: Color(0xFF202531),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: Text.rich(
                maxLines: 2,
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Album: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF202531),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    currentTrack.albumName == null || currentTrack.albumName == ""
                        ? const TextSpan(
                            text: "?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF202531),
                            ),
                          )
                        : TextSpan(
                            text: currentTrack.albumName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF202531),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Album artist: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  currentTrack.albumArtist == null ||
                          currentTrack.albumArtist == ""
                      ? const TextSpan(
                          text: "?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        )
                      : TextSpan(
                          text: currentTrack.albumArtist,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Year: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  currentTrack.year == null
                      ? const TextSpan(
                          text: "?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        )
                      : TextSpan(
                          text: currentTrack.year.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Genre: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  currentTrack.genre == null || currentTrack.genre == ""
                      ? const TextSpan(
                          text: "?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        )
                      : TextSpan(
                          text: currentTrack.genre,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                          ),
                        ),
                ],
              ),
            ),
            Text.rich(TextSpan(
              children: [
                const TextSpan(
                  text: "Track no: ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF202531),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                currentTrack.trackNumber != null
                    ? currentTrack.albumLength == null ||
                            currentTrack.albumLength == 0
                        ? TextSpan(
                            children: [
                              TextSpan(
                                text: currentTrack.trackNumber.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF202531),
                                ),
                              ),
                            ],
                          )
                        : TextSpan(
                            text:
                                "${currentTrack.trackNumber}/${currentTrack.albumLength}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF202531),
                            ),
                          )
                    : const TextSpan(
                        text: "?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF202531),
                        ),
                      ),
              ],
            )),
            Text.rich(
              TextSpan(
                children: [
                  currentTrack.trackDuration == null
                      ? const TextSpan(
                          text: "Duration: ?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF202531),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : TextSpan(
                          children: [
                            const TextSpan(
                              text: "Duration: ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF202531),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: formatedDuration(Duration(
                                  milliseconds:
                                      currentTrack.trackDuration!.toInt())),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF202531),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  const TextSpan(
                    text: "File: ",
                    style: TextStyle(
                      color: Color(0xFF202531),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: basename(currentTrack.file.absolute.path),
                    style: const TextStyle(
                      color: Color(0xFF202531),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
