import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../injection.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super("");

  // we save new language pref in SharedPrefs AND we emit the new lang atate
  void setLang(String lang) async {
    var sharedPreferences = sl<SharedPreferences>();
    sharedPreferences.setString("prefLang", lang);
    emit(lang);
  }
}
