import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';

import '../../../application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import '../../../generated/l10n.dart';

class AutomaticPlaybackSwitch extends StatelessWidget {
  const AutomaticPlaybackSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final automaticPlaybackCubit =
        BlocProvider.of<AutomaticPlaybackCubit>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: BlocBuilder<LanguageCubit, String>(
            builder: (context2, state) {
              return Text(
                S.of(context).drawer_automaticPlayback,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        SizedBox(
          width: 60,
          height: 44,
          child: FittedBox(
            fit: BoxFit.fill,
            child: BlocBuilder<AutomaticPlaybackCubit, bool>(
              builder: (context, state) {
                return Switch(
                  value: state,
                  onChanged: (value) {
                    automaticPlaybackCubit.setAutomaticPlayback(value);
                  },
                  // we set the theme here because SwitchThemeData has too few option :-(
                  inactiveThumbColor: const Color(0xFF202531).withOpacity(0.9),
                  inactiveTrackColor: const Color(0xFFCBD4C2).withOpacity(0.6),
                  activeColor: const Color(0xFFFF8100),
                  activeTrackColor: const Color(0xFFCBD4C2).withOpacity(0.2),
                  trackOutlineColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
