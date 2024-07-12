import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super("");

  void setLang(String lang) async {
    final Future<SharedPreferences> langPrefsI =
    SharedPreferences.getInstance();
    SharedPreferences langPrefs = await langPrefsI;
    langPrefs.setString("prefLang", lang);
    emit(lang);
  }
}
