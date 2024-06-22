import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../../../application/playercontrols/cubits/track_duration_cubit.dart';
import '../../../../application/playercontrols/cubits/track_position_cubit.dart';
import '../../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../../../injection.dart';
import '../../../../core/audiohandler.dart';
import '../../modal_bottomsheet/widgets/container_info_image.dart';
import '../../modal_bottomsheet/widgets/sizedbox_infotext.dart';

class PlayerControls extends StatelessWidget {
  final TrackEntity track;
  final Function gotoItem;

  const PlayerControls({
    super.key,
    required this.track,
    required this.gotoItem,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(context);
    final continuousPlaybackModeCubit =
        BlocProvider.of<ContinuousPlaybackModeCubit>(context);

    return Container(
      height: BlocProvider.of<PlayerControlsBloc>(context).state.height,
      width: MediaQuery.of(context).size.width - 20,
      decoration: const BoxDecoration(
        image: DecorationImage(
          //Image created with Copilot:
          // https://www.bing.com/images/create/ich-benc3b6tige-ein-bild-von-einer-halben-orangeschei/1-65eafbc9c71c45e09161671daedd3365?id=bqGe%2fr4j8q3G%2br6xfdQr1Q%3d%3d&view=detailv2&idpp=genimg&idpclose=1&thId=OIG2.S97rpDcp7mvO4Ayeq.Dz&frame=sydedg&FORM=SYDBIC
          image: AssetImage("assets/orange.jpeg"),
          fit: BoxFit.fitWidth,
          opacity: 0.25,
          alignment: Alignment.topCenter,
          colorFilter: ColorFilter.mode(
            Color(0xFFFF8100),
            BlendMode.darken,
          ),
        ),
        color: Color(0xFFFF8100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OrientationBuilder(builder: (context, orientation) {
            return SizedBox(
              width: orientation == Orientation.portrait ? 620 : 372,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 38,
                  ),
                  Expanded(
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
                  ),
                  IconButton(
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
                                      padding: const EdgeInsets.only(top: 8.0),
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
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF202531),
                    ),
                    iconSize: 22,
                  )
                ],
              ),
            );
          }),
          const SizedBox(
            height: 10,
          ),
          // Progressbar!
          OrientationBuilder(builder: (context, orientation) {
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
          }),
          const SizedBox(
            height: 10,
          ),
          // Buttons des Players!
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<LoopModeCubit, bool>(
                builder: (context, loopMode) {
                  return IconButton(
                    onPressed: () {
                      continuousPlaybackModeCubit
                          .setContinuousPlaybackMode(false);
                      loopMode
                          ? isLoopModeCubit.setLoopMode(false)
                          : isLoopModeCubit.setLoopMode(true);
                      loopMode
                          ? {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Loop playback is off"),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              ),
                            }
                          : {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Loop playback is on"),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              ),
                            };
                    },
                    icon: loopMode
                        ? const Icon(
                            Icons.repeat_one_rounded,
                            color: Color(0xFF202531),
                          )
                        : Icon(
                            Icons.repeat_one_rounded,
                            color: const Color(0xFF202531).withOpacity(0.4),
                          ),
                    iconSize: 22,
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<PlayerControlsBloc>(context)
                      .add(PreviousButtonPressed());
                  gotoItem(144.0);
                },
                icon: const Icon(
                  Icons.skip_previous_rounded,
                  color: Color(0xFF202531),
                ),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<PlayerControlsBloc>(context)
                      .add(PausePlayButtonPressed());
                },
                icon: !BlocProvider.of<PlayerControlsBloc>(context)
                        .state
                        .isPausing
                    ? const Icon(
                        Icons.pause_rounded,
                        color: Color(0xFF202531),
                      )
                    : const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF202531),
                      ),
                iconSize: 64,
              ),
              IconButton(
                onPressed: () {
                  BlocProvider.of<PlayerControlsBloc>(context)
                      .add(NextButtonPressed());
                  gotoItem(0.0);
                },
                icon: const Icon(
                  Icons.skip_next_rounded,
                  color: Color(0xFF202531),
                ),
                iconSize: 36,
              ),
              BlocBuilder<ContinuousPlaybackModeCubit, bool>(
                builder: (context, continuousPlaybackMode) {
                  return IconButton(
                    onPressed: () {
                      if (isLoopModeCubit.state == true) {
                        isLoopModeCubit.setLoopMode(false);
                      }
                      continuousPlaybackMode
                          ? continuousPlaybackModeCubit
                              .setContinuousPlaybackMode(false)
                          : continuousPlaybackModeCubit
                              .setContinuousPlaybackMode(true);
                      continuousPlaybackMode
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Continuous playback is off"),
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                              ),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Continuous playback is on"),
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                              ),
                            );
                    },
                    icon: continuousPlaybackMode
                        ? const Icon(
                            Icons.loop_rounded,
                            color: Color(0xFF202531),
                          )
                        : Icon(
                            Icons.loop_rounded,
                            color: const Color(0xFF202531).withOpacity(0.4),
                          ),
                    iconSize: 22,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
