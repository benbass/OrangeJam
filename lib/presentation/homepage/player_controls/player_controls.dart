import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/play_pause_button.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/progress_bar.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/track_info_text.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/skip_to_next_or_prev_button.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../application/playercontrols/cubits/loop_mode_cubit.dart';
import '../../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../domain/entities/track_entity.dart';

import '../modal_bottomsheet_track_details/bottomsheet_track_details.dart';
import 'widgets/continuous_playback_button.dart';
import 'widgets/loop_button.dart';

class PlayerControls extends StatelessWidget {
  final TrackEntity track;
  final ListObserverController observerController;

  const PlayerControls({
    super.key,
    required this.track,
    required this.observerController,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isLoopModeCubit = BlocProvider.of<LoopModeCubit>(context);
    final continuousPlaybackModeCubit =
        BlocProvider.of<ContinuousPlaybackModeCubit>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// 2 text lines for track info + button to open bottomSheet for track details
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
                    TrackInfoText(track: track, themeData: themeData),
                    BottomSheetTrackDetails(
                      themeData: themeData,
                      track: track,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            /// Progressbar
            OrientationBuilder(builder: (context, orientation) {
              return PlayerControlsProgressBar(orientation: orientation);
            }),
            const SizedBox(
              height: 10,
            ),
            // Buttons des Players!
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Loop button
                LoopButton(continuousPlaybackModeCubit: continuousPlaybackModeCubit, isLoopModeCubit: isLoopModeCubit),
                /// Skip to previous button
                SkipToNextOrPrevious(observerController: observerController, value: 0,),
                /// Play/Pause button
                const PlayPause(),
                /// Skip to next button
                SkipToNextOrPrevious(observerController: observerController, value: 1,),
                /// Continuous playback button
                ContinuousPlayback(isLoopModeCubit: isLoopModeCubit, continuousPlaybackModeCubit: continuousPlaybackModeCubit),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







