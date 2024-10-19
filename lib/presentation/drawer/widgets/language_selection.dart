import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/drawer_prefs/language/language_cubit.dart';
import '../../../generated/l10n.dart';
import '../../homepage/custom_widgets/custom_widgets.dart';

class LanguageSelection extends StatelessWidget {
  final List<Locale> supportedLang;
  const LanguageSelection({super.key, required this.supportedLang});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        Text(
          S.of(context).drawer_language,
          style: themeData.textTheme.displayLarge,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: supportedLang
              .map(
                (locale) => SimpleButton(
                  themeData: themeData,
                  btnText: locale.languageCode.toUpperCase(),
                  function: () {
                    BlocProvider.of<LanguageCubit>(context)
                        .setLang(locale.languageCode);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
