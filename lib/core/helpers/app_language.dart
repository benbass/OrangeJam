import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';

Future<String?> getLangFromPrefs() async {
  final Future<SharedPreferences> langPrefs = SharedPreferences.getInstance();
  final String? prefLang =
  await langPrefs.then((value) => value.getString("prefLang"));
  if(prefLang != null) {
    return prefLang;
  } else {
    return null;
  }
}

void setAppLanguage(BuildContext context){
  final String deviceLang = Localizations.localeOf(context).languageCode;
  final List<Locale> supportedLang = S.delegate.supportedLocales;
  getLangFromPrefs().then((value) {
    if(value == null){
      if(supportedLang.contains(Locale(deviceLang))){
        S.load(Locale(deviceLang));
      } else {
        S.load(const Locale('en'));
      }
    } else {
      // as per Aug. 2024 value can only be "en", "de" or "fr" if not null
      S.load(Locale(value));
    }
  });
}