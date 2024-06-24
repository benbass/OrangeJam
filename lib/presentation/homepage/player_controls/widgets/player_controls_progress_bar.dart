import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection.dart';
import '../../../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../../../core/audiohandler.dart';

class PlayerControlsProgressBar extends StatelessWidget {
  final Orientation orientation;
  const PlayerControlsProgressBar({
    super.key, required this.orientation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: orientation == Orientation.portrait
          ? const EdgeInsets.symmetric(
        horizontal: 20.0,
      )
          : EdgeInsets.zero, //340,
      child: BlocBuilder<TrackPositionCubit, Duration?>(
        builder: (context, p) {
          return BlocBuilder<TrackDurationCubit, Duration>(
            builder: (context, d) {
              return Row(
                children: [
                  Expanded(
                    child: ProgressBar(
                      progress: p ?? Duration.zero,
                      total: d,
                      progressBarColor:
                      const Color(0xFF202531).withOpacity(0.3),
                      baseBarColor:
                      const Color(0xFF202531).withOpacity(0.2),
                      bufferedBarColor: Colors.transparent,
                      thumbColor: const Color(0xFF202531),
                      barHeight: 10.0,
                      barCapShape: BarCapShape.round,
                      thumbRadius: 14.0,
                      timeLabelPadding: 8,
                      timeLabelType: TimeLabelType.totalTime,
                      timeLabelTextStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF202531),
                      ),
                      onSeek: (c) {
                        sl<MyAudioHandler>().gotoSeekPosition(c);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}