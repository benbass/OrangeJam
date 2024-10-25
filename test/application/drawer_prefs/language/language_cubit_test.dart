import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  group("Test Language Cubit method", () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(
          <String, String>{"prefLang": "DE"});
      await SharedPreferences.getInstance();
    });

    tearDown(() {});

    String pref = "DE";
    blocTest<LanguageCubit, String>(
        "Set bool with setAutomaticPlayback",
        build: () => LanguageCubit(),
        act: (cubit) => cubit.setLang(pref),
        expect: () => [pref]);

  });
}