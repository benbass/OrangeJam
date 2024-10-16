import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutomaticPlaybackCubit extends Cubit<bool> {
  AutomaticPlaybackCubit() : super(false);

  // we save new automatic playback pref in SharedPrefs AND we emit the new automatic state
  void setAutomaticPlayback(bool automaticPlayback) async {
    final Future<SharedPreferences> automaticPlaybackI =
    SharedPreferences.getInstance();
    SharedPreferences automaticPlaybackPrefs = await automaticPlaybackI;
    automaticPlaybackPrefs.setBool("prefAutomaticPlayback", automaticPlayback);
    emit(automaticPlayback);
  }

  // get pref and emit
  void getAutomaticPlaybackFromPrefs() async {
    final Future<SharedPreferences> automaticPlaybackI =
    SharedPreferences.getInstance();
    SharedPreferences automaticPlaybackPrefs = await automaticPlaybackI;
    bool result = automaticPlaybackPrefs.getBool(
        "prefAutomaticPlayback") ?? false;
    emit(result);
  }
}
