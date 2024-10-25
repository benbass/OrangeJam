import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../injection.dart';

Future<String?> getLangFromPrefs() async {
  var sharedPreferences = sl<SharedPreferences>();
  final String? prefLang = sharedPreferences.getString("prefLang");
  if (prefLang != null) {
    return prefLang;
  } else {
    return null;
  }
}

void setAppLanguage(BuildContext context) async {
  final String deviceLang = Localizations.localeOf(context).languageCode;
  final List<Locale> supportedLang = S.delegate.supportedLocales;
  String? prefLang = await getLangFromPrefs();
  if (prefLang == null) {
    /// no saved language pref:
    // we set app language == device language
    if (supportedLang.contains(Locale(deviceLang))) {
      S.load(Locale(deviceLang));
    } else {
      // or we set to default "en"
      S.load(const Locale('en'));
    }
  } else {
    /// saved language pref:
    // as per Aug. 2024 value can only be "en", "de" or "fr" if not null
    S.load(Locale(prefLang));
  }
}
