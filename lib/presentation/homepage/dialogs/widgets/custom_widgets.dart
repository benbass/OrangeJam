import 'dart:ui';

import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget content;
  final List<Widget> actions;
  final bool showDropdown;
  final Widget titleWidget;
  final ThemeData themeData;

  const CustomDialog({
    super.key,
    required this.content,
    required this.actions,
    required this.showDropdown,
    required this.titleWidget,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        title: titleWidget,
        backgroundColor: themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              if (showDropdown)
                const Placeholder() // DropDown?
            ],
          ),
        ),
        actions: actions,
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
    required this.themeData,
    required this.description,
  });

  final ThemeData themeData;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: themeData.dialogTheme.titleTextStyle,
    );
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.themeData,
    required this.btnText,
  });

  final ThemeData themeData;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: themeData.textButtonTheme.style,
      child: Text(
        btnText,
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.txtController,
    required this.themeData,
  });

  final TextEditingController txtController;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtController,
      autofocus: true,
      cursorColor: Colors.white54,
      decoration: const InputDecoration(
        focusColor: Colors.white54,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
      ),
      style: themeData.textTheme.bodyLarge!,
    );
  }
}
