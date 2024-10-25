import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../injection.dart';

class AutomaticPlaybackCubit extends Cubit<bool> {
  AutomaticPlaybackCubit() : super(false);

  // we save new automatic playback pref in SharedPrefs AND we emit the new automatic state
  void setAutomaticPlayback(bool automaticPlayback) async {
    var sharedPreferences = sl<SharedPreferences>();
    sharedPreferences.setBool("prefAutomaticPlayback", automaticPlayback);
    emit(automaticPlayback);
  }

  // get pref and emit
  void getAutomaticPlaybackFromPrefs() async {
    var sharedPreferences = sl<SharedPreferences>();
    bool result = sharedPreferences.getBool(
        "prefAutomaticPlayback") ?? false;
    emit(result);
  }
}
