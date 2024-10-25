import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group("Test Automatic Playback Cubit methods", () {

    late AutomaticPlaybackCubit automaticPlaybackCubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues(
          <String, bool>{"prefAutomaticPlayback": true});
      await SharedPreferences.getInstance();

      automaticPlaybackCubit = AutomaticPlaybackCubit();
    });

    tearDown(() {
      automaticPlaybackCubit.close();
    });

    blocTest<AutomaticPlaybackCubit, bool>(
        "Get bool from getAutomaticPlaybackFromPrefs",
        build: () => automaticPlaybackCubit,
        act: (cubit) => cubit.getAutomaticPlaybackFromPrefs(),
        expect: () => [true]);

    bool pref = true;
    blocTest<AutomaticPlaybackCubit, bool>(
        "Set bool with setAutomaticPlayback",
        build: () => automaticPlaybackCubit,
        act: (cubit) => cubit.setAutomaticPlayback(pref),
        expect: () => [pref]);

  });
}
