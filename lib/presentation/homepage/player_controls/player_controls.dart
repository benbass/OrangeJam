import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/play_pause_button.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/progress_bar.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/stop_button.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/track_info_text.dart';
import 'package:orangejam/presentation/homepage/player_controls/widgets/skip_to_next_or_prev_button.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../application/playercontrols/bloc/playercontrols_bloc.dart';

import '../modal_bottomsheet_track_details/bottomsheet_track_details.dart';
import 'widgets/shuffle_button.dart';
import 'widgets/loop_button.dart';

class PlayerControls extends StatelessWidget {
  final ListObserverController observerController;

  const PlayerControls({
    super.key,
    required this.observerController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerControlsBloc, PlayerControlsState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          height: state.height,
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
                        TrackInfoText(
                          track: state.track,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BottomSheetTrackDetails(
                              track: state.track,
                            ),
                          ],
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
                    const LoopButton(),

                    /// Skip to previous button
                    SkipToNextOrPrevious(
                      observerController: observerController,
                      value: 0,
                    ),

                    const SizedBox(
                      width: 128,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Play/Pause button
                          PlayPause(),

                          /// Stop button
                          Stop(),
                        ],
                      ),
                    ),

                    /// Skip to next button
                    SkipToNextOrPrevious(
                      observerController: observerController,
                      value: 1,
                    ),

                    /// Continuous playback button
                    const ShuffleButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
